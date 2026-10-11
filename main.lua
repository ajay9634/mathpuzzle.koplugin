local WidgetContainer = require("ui/widget/container/widgetcontainer")
local InputDialog = require("ui/widget/inputdialog")
local ConfirmBox = require("ui/widget/confirmbox")
local UIManager = require("ui/uimanager")
local _ = require("gettext")

local MathPuzzle = WidgetContainer:extend{
    name = "mathpuzzle",
}

function MathPuzzle:init()
    self.ui.menu:registerToMainMenu(self)
    self.correct_count = 0
    self.total_count = 0
    self.current_streak = 0
    self.best_streak = 0
    self.digit_level = 2
    self.selected_op = "ALL" -- "ALL", "+", "-", "×", "÷"
end

function MathPuzzle:addToMainMenu(menu_items)
    menu_items.math_puzzle = {
        text = _("Math Calculation Puzzle Game"),
        sorting_hint = "more_tools",
        callback = function()
            self.correct_count = 0
            self.total_count = 0
            self.current_streak = 0
            self:startNewGame()
        end,
    }
end

function MathPuzzle:getNumberRange(digits)
    if digits == 1 then return 2, 9 end
    local min = 10 ^ (digits - 1)
    local max = (10 ^ digits) - 1
    return min, max
end

function MathPuzzle:generatePuzzle()
    math.randomseed(os.time())
    local ops = { "+", "-", "×", "÷" }
    local op = self.selected_op
    
    if op == "ALL" then
        op = ops[math.random(1, #ops)]
    end

    local min_val, max_val = self:getNumberRange(self.digit_level)
    local n1, n2, expected_result

    if op == "+" then
        n1 = math.random(min_val, max_val)
        n2 = math.random(min_val, max_val)
        expected_result = n1 + n2
    elseif op == "-" then
        n1 = math.random(min_val, max_val)
        n2 = math.random(min_val, n1)
        expected_result = n1 - n2
    elseif op == "×" then
        if self.digit_level > 2 then
            n1 = math.random(min_val, max_val)
            n2 = math.random(2, 20)
        else
            n1 = math.random(min_val, max_val)
            n2 = math.random(2, 12)
        end
        expected_result = n1 * n2
    elseif op == "÷" then
        local quotient = math.random(min_val, max_val)
        n2 = math.random(2, (self.digit_level > 2 and 20 or 12))
        n1 = quotient * n2
        expected_result = quotient
    end

    return {
        equation_str = string.format("%d %s %d", n1, op, n2),
        expected_result = expected_result
    }
end

function MathPuzzle:openSettingsDialog()
    local settings_dialog
    settings_dialog = InputDialog:new{
        title = _("Game Settings"),
        description = string.format(
            _("Current Settings:\n• Digits: %d\n• Operation: %s\n\nEnter digits (1-5) or choose options below:"),
            self.digit_level, self.selected_op
        ),
        input_type = "number",
        buttons = {
            {
                {
                    text = _("Op: " .. self.selected_op),
                    callback = function()
                        local next_ops = { ALL = "+", ["+"] = "-", ["-"] = "×", ["×"] = "÷", ["÷"] = "ALL" }
                        self.selected_op = next_ops[self.selected_op] or "ALL"
                        UIManager:close(settings_dialog)
                        self:openSettingsDialog()
                    end,
                },
                {
                    text = _("2 Digits"),
                    callback = function()
                        self.digit_level = 2
                        UIManager:close(settings_dialog)
                        self:startNewGame()
                    end,
                },
                {
                    text = _("3 Digits"),
                    callback = function()
                        self.digit_level = 3
                        UIManager:close(settings_dialog)
                        self:startNewGame()
                    end,
                },
                {
                    text = _("Save"),
                    id = "ok",
                    is_default = true,
                    callback = function()
                        local input = tonumber(settings_dialog:getInputText())
                        if input and input >= 1 and input <= 5 then
                            self.digit_level = math.floor(input)
                        end
                        UIManager:close(settings_dialog)
                        self:startNewGame()
                    end,
                },
            },
        },
    }
    UIManager:show(settings_dialog)
    settings_dialog:onShowKeyboard()
end

function MathPuzzle:startNewGame()
    local puzzle = self:generatePuzzle()

    local dialog
    dialog = InputDialog:new{
        title = string.format(
            _("Math Puzzle (%dD | %s) - Score: %d/%d (Streak: %d)"),
            self.digit_level, self.selected_op, self.correct_count, self.total_count, self.current_streak
        ),
        description = string.format(
            _("Solve the equation:\n\n   %s = ?\n\nEnter your answer below:"),
            puzzle.equation_str
        ),
        input_type = "number",
        buttons = {
            {
                {
                    text = _("Exit"),
                    id = "close",
                    callback = function()
                        UIManager:close(dialog)
                    end,
                },
                {
                    text = _("Settings"),
                    callback = function()
                        UIManager:close(dialog)
                        self:openSettingsDialog()
                    end,
                },
                {
                    text = _("Submit"),
                    id = "ok",
                    is_default = true,
                    callback = function()
                        local user_input = dialog:getInputText()
                        UIManager:close(dialog)
                        self:verifyAnswer(user_input, puzzle)
                    end,
                },
            },
        },
    }
    
    UIManager:show(dialog)
    dialog:onShowKeyboard()
end

function MathPuzzle:verifyAnswer(user_input, puzzle)
    if not user_input or user_input == "" then
        self:startNewGame()
        return
    end

    self.total_count = self.total_count + 1
    local user_num = tonumber(user_input)
    local msg_text = ""

    if not user_num then
        msg_text = _("Please enter a valid number!")
    elseif user_num == puzzle.expected_result then
        self.correct_count = self.correct_count + 1
        self.current_streak = self.current_streak + 1
        if self.current_streak > self.best_streak then
            self.best_streak = self.current_streak
        end

        msg_text = string.format(
            _("Correct! 🎉\n\n%s = %d\n\nScore: %d/%d | Current Streak: 🔥 %d (Best: %d)"),
            puzzle.equation_str, puzzle.expected_result, self.correct_count, self.total_count, self.current_streak, self.best_streak
        )
    else
        self.current_streak = 0
        msg_text = string.format(
            _("Incorrect! ❌\n\nEquation: %s\nYour Answer: %d\nCorrect Answer: %d\n\nScore: %d/%d | Streak reset to 0"),
            puzzle.equation_str, user_num, puzzle.expected_result, self.correct_count, self.total_count
        )
    end

    self:showResultDialog(msg_text)
end

function MathPuzzle:showResultDialog(msg_text)
    local confirm_box
    confirm_box = ConfirmBox:new{
        text = msg_text,
        cancel_text = _("Exit Game"),
        cancel_callback = function()
            UIManager:close(confirm_box)
        end,
        ok_text = _("Next Puzzle"),
        ok_callback = function()
            UIManager:close(confirm_box)
            self:startNewGame()
        end,
    }
    UIManager:show(confirm_box)
end

return MathPuzzle
