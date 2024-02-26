Привет, Меня зовут Роман, я один из авторов курса iOS.
Сегодня мы с вами посмотрим на код учебного проекта FantasyUnitsConverter и сделаем его рефакторинг.
Давайте запустим и посмотрим. У нас два экрана с возможностью переключения между ними.
На экране конвертера можно выбрать единицу измерения, ввести значение и получим значение в другой системе единиц. В истории видно, какие конвертации мы делали.

Давайте перейдем к коду. В данном случае он специально написан плохо. Но не думайте, что такое бывает только в учебниках, в боевых проектах к сожалению тоже может встречаться по разным причинам. Например, код писали на аутсорсе, не особо заботясь о качестве, или просто нужно было сделать очень быстро.

В AppDelegate мы видим, что основным контроллером является ConverterViewController, посмотрим его код. Видим что он большой, и непонятно чем занимается.
Чуть-чуть покопавшись в коде, увидим, что большой он потому что содержит в себя все подряд: и UI экрана конвертации, и UI экрана истории, и переключение между ними. А мы хотим придти к сингл респонсибилити, или хотя бы приблизиться к этому.


//Тесты после рефакторинга сломались нахрен, хочется их вообще выпилить, а то сильно больше времени уйдет 

//TODO: переименовать ConverterViewController в MainViewController

Для начала давайте вынесем весь UI экрана конверсии в отдельный вью.
Создадим новый файл и объявим в нем класс ConvertationViewController.
Перенесем в него лейблы и текстфилд, отвечающие за UI конвертации, из ConverterViewController. 
Мы увидим, что функции tapFrom, tapTo и textFieldDidChange внутри себя используют другие объекты и классы, и нам сложно перетащить их в ConvertationViewController. Это говорит о плохом дизайне кода, будем это исправлять по шагам. Сначала запустим приложение и убедимся, что наш UI корректно отображается.

https://github.com/Seify/FantasyUnitsConverter/commit/db8195a6c10a1470b0189b69a671c482015cf91a

Теперь давайте добавим интерактива, и обработаем тапы на лейблах с единицами измерений.
Можно это сделать через замыкания, можно через делегаты. Я сделаю через делегаты.
Добавим протокол ConvertationViewControllerDelegate, в нем три метода didTapFrom(), didTapTo()
и didUpdateAmount(). Добавим переменную delegate в ConverterViewController. В функции tapFrom, tapTo и textFieldDidChange добавим вызовы соответствующих методов делегата.

    @objc func tapFrom() {
        view.endEditing(true)

        delegate?.didTapFrom()
    }

    @objc func tapTo() {
        view.endEditing(true)

        delegate?.didTapTo()
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        delegate?.didUpdateAmount()
    }

Теперь перейдем в ConverterViewController и реализуем в нем протокол делегата в экстеншн.

extension ConverterViewController: ConvertationViewControllerDelegate {
    func didTapFrom() {
        units = FantasticUnits.allCases
        unitTableView.reloadData()
        isFirstUnitSelecting = true
        isSecondUnitSelecting = false
        unitTableView.isHidden = false
    }
    
    func didTapTo() {
        isFirstUnitSelecting = false
        isSecondUnitSelecting = true
        unitTableView.isHidden = false
    }

    func didUpdateAmount() {
        convert()
    }
}

И теперь зададим значение переменной делегата в ConvertationViewController.

Так как мы перенесли из ConverterViewController все лейблы в ConvertationViewController, добавим функции для отображения значений результата и выбранных единиц измерений:

	func show(result: Double) {
        labelResult.text = "Результат: \(result)"
    }

    func show(from text: String) {
        labelSelectedFromUnit.text = text
    }

    func show(to text: String) {
        labelSelectedToUnit.text = text
    }

Еще нам понадобится вычисляемая переменная для amount

    var amount: Double {
        guard let textAmount = textFieldAmount.text, let doubleAmount = Double(textAmount) else {
            return 0
        }
        return doubleAmount
    }

Установим делегата для ConvertationViewController:

    lazy var convertationViewController = {
        let controller = ConvertationViewController()
        controller.delegate = self

        return controller
    }()

Мы объявили переменную как var чтобы гарантировать, значение self уже будет присвоено к моменту ее создания.

Заменим закомментированные ранее участки кода в ConverterViewController, используя в них новые функции и переменные

https://github.com/Seify/FantasyUnitsConverter/commit/2d2095cf27569d7f2bfc372891848e51b3f7d6eb

Давайте теперь вынесем историю в отдельный контроллер. Создадим класс HistoryViewController и перенесем в него historyTableView.

Добавим переменную conversionHistory и функцию обновления:

	var conversionHistory: [ConversionEvent] = []

    func update(history: [ConversionEvent]) {
        conversionHistory = history
        tableView.reloadData()
    }

Теперь переменная isShowingConverter нам нужна только в switchState, сделаем ее локальной и удалим в остальных местах. Проверим, что все работает.

https://github.com/Seify/FantasyUnitsConverter/commit/1f423df40ebf9c0b15fba1a0e34d0f3b3707e9ca

Аналогично, вынесем unitTableView в отдельный контроллер UnitSelectionViewController, добавим ему замыкание onSelection.
Сделаем, чтобы он не всегда висел в памяти, а показывался только при необходимости. Это 
При клике на выбор первой или второй единицы измерения открывается контроллер unitSelectionViewController. Он всегда присутствует в памяти, и всякий раз обновляется. Это требует дополнительных переменных для хранения его текущего состояния isFirstUnitSelecting и isSecondUnitSelecting, что потенциально сопряжено с ошибками. Давайте сделаем так, чтобы он существовал только то время, пока нам нужен, и используем present для показа. isFirstUnitSelecting, isSecondUnitSelecting, unitTableView и констрейнты для него можно удалить

    func didTapFrom() {
        let controller = UnitSelectionViewController()
        controller.units = FantasticUnits.allCases
        controller.onSelection = { [weak self] unit in
            self?.convertationViewController.show(to: "Нажми для выбора единицы измерения")
            self?.selectedFromUnit = unit
            self?.selectedToUnit = nil
            self?.convertationViewController.show(from: unit.title)
            self?.dismiss(animated: true)
        }
        present(controller, animated: true)
    }
    
    func didTapTo() {
        let units = FantasticUnits.possibleConversions(for: selectedFromUnit!)
        let controller = UnitSelectionViewController()
        controller.units = units
        controller.onSelection = {[weak self] unit in
            self?.selectedToUnit = unit
            self?.convertationViewController.show(to: unit.title)
            self?.dismiss(animated: true)
        }
        present(controller, animated: true)
    }

https://github.com/Seify/FantasyUnitsConverter/commit/281dba13ae1011adb2e6a59f7dc44d3b1a0de35e

Логика работы с UI конвертации у нас сейчас размазана между ConvertationViewController и ConverterViewController. Чтобы это починить, давайте перенесем selectedFromUnit и selectedToUnit в ConvertationViewController.

    var selectedFromUnit: FantasticUnits? = nil {
        didSet {
            if let selectedFromUnit {
                labelSelectedFromUnit.text = selectedFromUnit.title
            } else {
                labelSelectedFromUnit.text = "Нажми для выбора единицы измерения"
            }
        }
    }

    var selectedToUnit: FantasticUnits? = nil {
        didSet {
            if let selectedToUnit {
                labelSelectedFromUnit.text = selectedToUnit.title
            } else {
                labelSelectedFromUnit.text = "Нажми для выбора единицы измерения"
            }
        }
    }

https://github.com/Seify/FantasyUnitsConverter/commit/02cf1654aaa63b61bd958212662f5f7f2f13de2d

Давайте теперь посмотрим на ConverterController. Это класс совмещает в себе несколько ответственностей: конвертацию, показ ошибок, работу с историей.
Для начала давайте уберем из него показ ошибки с конвертацией. Создадим ошибку 

enum ConversionError: Error {
    case unsupportedPair
}

и если пара не поддерживается, будем ее бросать в функции convert:

...
        case (.moscowSecond, .realSecond):
            outputValue = value / 1000
        case (.realSecond, .moscowSecond):
            outputValue = value * 1000.0

        default:
            throw(ConversionError.unsupportedPair)
        }

Эту ошибку обработаем во вьюконтроллере:

    func convert() {
        guard let selectedFromUnit = convertationViewController.selectedFromUnit,
              let selectedToUnit = convertationViewController.selectedToUnit else {
            return
        }
        do {
            let result = try ConverterController.shared.convert(from: selectedFromUnit, to: selectedToUnit, amount: convertationViewController.amount)
            convertationViewController.show(result: result)
        } catch ConversionError.unsupportedPair {
            showError(title: "Ошибка", message: "Пара не поддерживается")
        } catch {
            showError(title: "Ошибка", message: "Неизвестная ошибка")
        }
    }


        //MARK: - Error Handling

    func showError(title: String, message: String) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            alertController.dismiss(animated: false)
        }
        alertController.addAction(okAction)

        present(alertController, animated: true)
    }

https://github.com/Seify/FantasyUnitsConverter/commit/8059272294f6df04119ec31b612d5a298bc7ff7c

Теперь перенесем историю в отдельный контроллер. Реализуем зависимости через протокол.

protocol History {
    func addConversion(from fromUnit: FantasticUnits, to toUnit: FantasticUnits, value: Double)
    var conversionHistory: [ConversionEvent] { get }
}

final class ConversionHistory: History {
    private (set) var conversionHistory: [ConversionEvent] = []

    func addConversion(from fromUnit: FantasticUnits,
                       to toUnit: FantasticUnits,
                       value: Double) {
        let event = ConversionEvent(
            fromUnit: fromUnit,
            toUnit: toUnit,
            outputValue: value,
            timestamp: Date()
        )
        addRecordToHistory(event)
    }

    private func addRecordToHistory(_ event: ConversionEvent) {
        conversionHistory.append(event)
    }

    func clearHistory() {
        conversionHistory.removeAll()
    }

    func findInHistory(query: (ConversionEvent) -> Bool) -> [ConversionEvent] {
        conversionHistory.filter(query)
    }
}

https://github.com/Seify/FantasyUnitsConverter


Как видно, рефакторинг практически полностью повторяет процесс написания кода. Поэтому сразу пишите хороший код и не пишите плохой код.
