import UIKit
import PlaygroundSupport
import UIKitCellConfigurator
import UIKitCellConfiguratorHelpers

//: ## Models

struct Weather {
    let conditions: String
    let temp: Float
    let unit: String
    let relativeDate: String
}

struct Reminders {
    let dueDate: String
    let items: [String]
}

struct Event {
    let name: String
    let date: String
}

//: ## Views

class WeatherView: CardView {
    private let temperatureLabel = UILabel()
    private let dateLabel = UILabel()

    override func setup() {
        addArrangedSubview(temperatureLabel)
        addArrangedSubview(dateLabel)
    }

    func updateWeather(
        temperatureString: String,
        dateString: String
    ) {
        temperatureLabel.text = temperatureString
        dateLabel.text = dateString
    }
}

class RemindersView: CardView {
    private let dueLabel = UILabel()

    func updateReminders(
        dueDateString: String,
        list: [String]
    ) {
        removeAllArrangedSubviews()

        dueLabel.text = "Reminders for \(dueDateString)"
        addArrangedSubview(dueLabel)

        for item in list {
            let label = UILabel()
            label.text = "🔲 \(item)"
            addArrangedSubview(label)
        }
    }
}

class EventView: CardView {
    private let dateLabel = UILabel()
    private let nameLabel = UILabel()

    override func setup() {
        addArrangedSubview(nameLabel)
        addArrangedSubview(dateLabel)
    }

    func updateEvent(
        name: String,
        dueDateString: String
    ) {
        nameLabel.text = "🗓 \(name)"
        dateLabel.text = dueDateString
    }
}

//: ## View model

class CardsViewModel {
    private var cards = [Card]()

    typealias Completion = () -> Void

    enum Card {
        case weather(Weather)
        case reminders(Reminders)
        case event(Event)
    }

    var fetch: (Completion) -> Void = { $0() /* Complete immediately by default */ }

    init(cardService: @escaping () -> [Card]) {
        fetch = { [weak self] completion in
            self?.cards = cardService()
            completion()
        }
    }

    func card(at indexPath: IndexPath) -> Card {
        cards[indexPath.item]
    }

    func numberOfItems(in section: Int) -> Int {
        cards.count
    }
}

//: ## Cell configurators

let weatherCellConfigurator = CellConfigurator(
    modelClass: Weather.self,
    cellClass: CollectionViewContainerCell<WeatherView>.self,
    configureCell: { model, cell in
        cell.view.updateWeather(
            temperatureString: "\(model.conditions) \(model.temp)° \(model.unit)",
            dateString: model.relativeDate
        )
    }
)

let remindersCellConfigurator = CellConfigurator(
    modelClass: Reminders.self,
    cellClass: CollectionViewContainerCell<RemindersView>.self,
    configureCell: { model, cell in
        cell.view.updateReminders(
            dueDateString: model.dueDate,
            list: model.items
        )
    }
)

let eventCellConfigurator = CellConfigurator(
    modelClass: Event.self,
    cellClass: CollectionViewContainerCell<EventView>.self,
    configureCell: { model, cell in
        cell.view.updateEvent(
            name: model.name,
            dueDateString: model.date
        )
    }
)

//: ## Collection view layout

func cardLayout() -> UICollectionViewFlowLayout {
    let spacing = CGFloat(16)
    let layout = UICollectionViewFlowLayout()

    layout.sectionInset = UIEdgeInsets(
        top: spacing,
        left: spacing,
        bottom: spacing,
        right: spacing
    )
    layout.minimumLineSpacing = spacing
    layout.minimumInteritemSpacing = spacing
    layout.estimatedItemSize = CGSize(
        width: 300,
        height: 100
    )
    return layout
}

//: ## Card service

func cardService() -> [CardsViewModel.Card] {
    [
        .weather(Weather(conditions: "🌦", temp: 14, unit: "C", relativeDate: "Today")),
        .event(Event(
                name: "Standup Meeting",
                date: "10:00 Today"
        )),
        .reminders(Reminders(
            dueDate: "Today",
            items: [
                "Call vet"
            ]
        )),
        .weather(Weather(conditions: "🌤", temp: 11, unit: "C", relativeDate: "Tomorrow")),
        .event(Event(
            name: "Standup Meeting",
            date: "10:00 Tomorrow"
        )),
        .event(Event(
            name: "Sync Meeting",
            date: "11:15 Tomorrow"
        )),
        .reminders(Reminders(
            dueDate: "Tomorrow",
            items: [
                "Get milk",
                "Pay water bill"
            ]
        )),
        .event(Event(
            name: "Standup Meeting",
            date: "10:00 Monday, Next week"
        )),
    ]
}

//: ## Collection view

let viewModel = CardsViewModel(cardService: cardService)
let collection = CollectionViewController(collectionViewLayout: cardLayout())

collection.collectionView.backgroundColor = .systemGroupedBackground

collection.register(cellType: weatherCellConfigurator.cellType)
collection.register(cellType: remindersCellConfigurator.cellType)
collection.register(cellType: eventCellConfigurator.cellType)

collection.numberOfItems = viewModel.numberOfItems

collection.cellForItemAt = { cv, ip in
    switch viewModel.card(at: ip) {

    case let .weather(weather):
        return weatherCellConfigurator.configure(
            withModel: weather, collectionView: cv, indexPath: ip
        )

    case let .reminders(reminders):
        return remindersCellConfigurator.configure(
            withModel: reminders, collectionView: cv, indexPath: ip
        )

    case let .event(event):
        return eventCellConfigurator.configure(
            withModel: event, collectionView: cv, indexPath: ip
        )
    }
}

viewModel.fetch {
    collection.collectionView.reloadData()
}

PlaygroundPage.current.liveView = collection
