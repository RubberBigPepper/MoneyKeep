//
//  CalculatorView.swift
//  MoneyKeep
//
//  Created by Albert on 23.09.2020.
//  Copyright © 2020 Albert. All rights reserved.
//

import UIKit

protocol CalculatorViewResult {
    func resultChanged(_ result: Double?)
}
//класс реализует калькулятор, написан по мотивам статьи на хабре
// https://habr.com/ru/company/otus/blog/514108/
class CalculatorView: UIView {

    let errorStr = "Error"
    
    private var firstNumber: Double = 0
    private var resultNumber: Double = 0
    private var currentOperations: Operation?

    //цвета кнопок
    private var colorNumCell = UIColor.white //кнопки цифр и точк
    private var colorOperationCell = UIColor.init(red: 2, green: 0.8, blue: 0, alpha: 1) //операции
    private var colorSpecSell = UIColor.lightGray //специальные (стереть)
    private var colorHighlighted = UIColor.green
    private var colorTextCell = UIColor.black
    
    enum Operation {
        case add, subtract, multiply, divide, percent
    }
    
    public var result: Double?{
        get{
            if let text = resultLabel.text, let value = Double(text) { return value }
            return nil
        }
    }
    
    public var delegate: CalculatorViewResult? = nil
    
    private var resultLabel: UILabel = {//
        let label = UILabel()
        label.backgroundColor = UIColor.gray
        label.text = "0"
        label.textColor = UIColor.white
        label.textAlignment = .right
        label.font = UIFont(name: "Helvetica", size: 40)
        label.adjustsFontSizeToFitWidth = true
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.25
        return label
    }()
    
    override func layoutSubviews() {
        setupNumberPad()
        resultLabel.addObserver(self, forKeyPath: "text", options: [.old, .new], context: nil)

        let tap = UITapGestureRecognizer(target: self, action: #selector(onTapResultLabel))
        resultLabel.isUserInteractionEnabled = true
        resultLabel.addGestureRecognizer(tap)
    }

    private func getAllBtns()->[UIButton]{//возьмем все баттоны
        var res: [UIButton] = []
        for view in subviews{
            if view is UIButton {
                res.append(view as! UIButton)
            }
        }
        return res
    }
    
    @objc func onTapResultLabel(sender:UITapGestureRecognizer) {//юзер нажал лабель - покажем ему анимацией, что нужно тыкать цифровые кнопки
        let btns = getAllBtns()
        UIView.animate(withDuration: 5, animations: {
            for btn in btns{
                btn.setTitleColor(self.colorHighlighted, for: .normal)
            }
        }, completion: { complected in
            for btn in btns{
                btn.setTitleColor(self.colorTextCell, for: .normal)
            }
        })
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
      if keyPath == "text" {
        let newText=change?[.newKey]
        if let text=newText as? String, let value = Double(text) {
            self.delegate?.resultChanged(value)
        }
        else{
            self.delegate?.resultChanged(nil)
        }
      }
    }
    
    private func setupButton(_ frame: CGRect, _ title: String,_ colorBG: UIColor, _ tag: Int, _ action: Selector?){
        //подготовка одной кнопки, будем вызывать для всех для краткости
        let resBtn = UIButton(frame: frame)
        resBtn.setTitleColor(self.colorTextCell, for: .normal)
        resBtn.setBackgroundColor(colorBG, for: .normal)
        resBtn.setBackgroundColor(self.colorHighlighted, for: .highlighted)
        resBtn.setTitle(title, for: .normal)
        resBtn.tag = tag
        if action != nil {
            resBtn.addTarget(self, action: action!, for: .touchUpInside)
        }
        self.addSubview(resBtn)
    }
    
    private func setupNumberPad() {//инициализируем и расположим все элементы
        let buttonSizeX: CGFloat = frame.size.width / 4 //по X четыре ряда кнопок
        let buttonSizeY: CGFloat = frame.size.height / 6 //по Y пять радов кнопок и один ряд для лабели
        
        setupButton(CGRect(x: 0, y: self.frame.size.height-buttonSizeY, width: buttonSizeX, height: buttonSizeY),
                    "0", self.colorNumCell, 1, #selector(zeroTapped))
        setupButton(CGRect(x: buttonSizeX, y: self.frame.size.height-buttonSizeY, width: buttonSizeX, height: buttonSizeY),
                    ".", self.colorNumCell, 2, #selector(decimalTapped))
        setupButton(CGRect(x: buttonSizeX * 2, y: self.frame.size.height-buttonSizeY, width: buttonSizeX, height: buttonSizeY),
                    "%", self.colorOperationCell, 3, #selector(percentTapped))
        var number=1
        for y in 2..<5 {//остальные цифровые кнопки
            for x in 0..<3{
                let rect=CGRect(x: buttonSizeX * CGFloat(x), y: self.frame.size.height-buttonSizeY * CGFloat(y), width: buttonSizeX, height: buttonSizeY)
                setupButton(rect,"\(number)", self.colorNumCell, number, #selector(numberPressed))
                number+=1
            }
        }
        setupButton(CGRect(x: 0, y: buttonSizeY, width: buttonSizeX*2, height: buttonSizeY),
                    "CE", self.colorSpecSell, 1, #selector(clearResult))
        
        setupButton(CGRect(x: buttonSizeX*2, y: buttonSizeY, width: buttonSizeX, height: buttonSizeY),
                    "<<", self.colorSpecSell, 1, #selector(backSpace))
        
        let operations = ["=","+", "-", "x", "÷"]
        
        for x in 0..<operations.count {
            let rect=CGRect(x: buttonSizeX * 3, y: frame.size.height-(buttonSizeY * CGFloat(x+1)), width: buttonSizeX, height: buttonSizeY)
            setupButton(rect,operations[x], self.colorOperationCell, x+1, #selector(operationPressed))
        }
        resultLabel.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: buttonSizeY)

        self.addSubview(resultLabel)
    }
    
    @objc func backSpace() {//затираем по одному
        if let text=resultLabel.text {
            if text.count<=1 { resultLabel.text="0" }
            else{
                resultLabel.text = String(text.prefix(text.count-1))
            }
        }
    }
    
    @objc func clearResult() {//очистка результата
        resultLabel.text = "0"
        currentOperations = nil
        firstNumber = 0
    }
    
    @objc func zeroTapped() {//нажатие на ноль
        if resultLabel.text != "0" {
            if let text = resultLabel.text {
                resultLabel.text = "\(text)\(0)"
            }
        }
    }
    
    @objc func decimalTapped() {//десятичная точка
        if resultLabel.text?.firstIndex(of: ".") == nil {//еще нет запятой - добавляем
            if let text = resultLabel.text {
                resultLabel.text = "\(text)."
            }
        }
    }
    
    @objc func percentTapped() {//нажали знак процентов - то есть введенное число преобразуем в долю (для умножения в будущем)
        if let text = resultLabel.text, let value = Double(text) {
            resultLabel.text = "\(value*0.01)"
        }
    }
    
    @objc func numberPressed(_ sender: UIButton) {//цифру нажали
        let tag = sender.tag
        if resultLabel.text == "0" {
            resultLabel.text = "\(tag)"
        }
        else if let text = resultLabel.text {
            resultLabel.text = "\(text)\(tag)"
        }
    }
    
    @objc func operationPressed(_ sender: UIButton) {//нажали одну из 5 операций
        let tag = sender.tag
        
        if let text = resultLabel.text, let value = Double(text), firstNumber == 0 {
            firstNumber = value
            resultLabel.text = "0"
        }
        
        switch tag {
        case 1: //равно
            if let operation = currentOperations {
                var secondNumber: Double = 0
                if let text = resultLabel.text, let value = Double(text) {
                    secondNumber = value
                }
                
                switch operation {
                case .add:
                    resultLabel.text = "\(Float(firstNumber + secondNumber))"
                    break
                case .subtract:
                    resultLabel.text = "\(Float(firstNumber - secondNumber))"
                    break
                case .multiply:
                    resultLabel.text = "\(Float(firstNumber * secondNumber))"
                    break
                case .divide:
                    if secondNumber == 0 {//делить на 0 нельзя
//                        resultLabel.text = errorStr
                        return
                    }
                    else{
                        resultLabel.text = "\(Float(firstNumber / secondNumber))"
                    }
                    break
                case .percent:
                    break
                }
                secondNumber=0
                firstNumber=0
                currentOperations = nil
            }
            break
        case 2:
            currentOperations = .add
            break
        case 3:
            currentOperations = .subtract
            break
        case 4:
            currentOperations = .multiply
            break
        case 5:
            currentOperations = .divide
            break
        default:
            break
        }
    }
}

extension UIButton {
    private func imageWithColor(color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()

        context?.setFillColor(color.cgColor)
        context?.fill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }

    public func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        self.setBackgroundImage(imageWithColor(color: color), for: state)
    }
    
}
