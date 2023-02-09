import Cocoa
import ArgumentParser

enum CalculatorErrors: String, LocalizedError {
    case emptyExpression = "Expression cannot be empty"
    case invalidExpression = "Invalid expression"
    var errorDescription: String? {
        self.rawValue
    }
}

typealias Operator = (Int, Int) -> Int
let operators: [String: Operator] = [
    "add": (+), "multiply": (*)
]

struct Calculator: ParsableCommand {
    @Argument(help: "Input string (e.g. \"(add 2 3)\")")
    var expression: String
    static var configuration = CommandConfiguration(
      commandName: "expression",
      abstract: "S-expression Calculator",
      discussion: "Command line program that takes a single argument as an expression and prints out the integer result of evaluating it."
    )

    func run() throws {
        guard CommandLine.argc == 2 else { throw CalculatorErrors.invalidExpression }
        guard !expression.isEmpty else { throw CalculatorErrors.emptyExpression }
        var chars = tokenizeExpr(CommandLine.arguments[1])
        let value = try processExpr(&chars)
        print(try evaluate(value))
    }

    func tokenizeExpr(_ str: String) -> [String] {
        let str = str.replacingOccurrences(of: "(", with: "( ").replacingOccurrences(of: ")", with: " )")
        let components = str.components(separatedBy: " ")
        return components
    }

    func processExpr(_ chars: inout [String]) throws -> Any {
        guard !chars.isEmpty else { throw CalculatorErrors.invalidExpression }
        let char = chars.removeFirst()
        if char == "(" {
            var exprArr = [Any]()
            while !chars.isEmpty && chars[0] != ")" {
                exprArr.append(try processExpr(&chars))
            }
            guard !chars.isEmpty else { throw CalculatorErrors.invalidExpression }
            chars.removeFirst()
            return exprArr
        }
        else {
            if let val = Int(char) { return val }
            else { return char }
        }
    }

    func evaluate(_ val: Any) throws -> Int {
        if let val = val as? Int { return val }
        if let arr = val as? [Any] {
            guard arr.count == 3 else { throw CalculatorErrors.invalidExpression }
            let num1 = arr[1], num2 = arr[2]
            if let operators = operators[arr[0] as! String] {
                return operators(try evaluate(num1), try evaluate(num2))
            }
            else {
                throw CalculatorErrors.invalidExpression
            }
        }
        else {
            throw CalculatorErrors.invalidExpression
        }
    }
}

Calculator.main()
