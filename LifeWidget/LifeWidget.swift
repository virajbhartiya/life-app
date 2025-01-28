import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        let currentDate = Date()
        for hourOffset in 0..<24 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct LifeWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        let calendar = Calendar.current
        let currentHour = calendar.component(.hour, from: entry.date)
        let currentMinute = calendar.component(.minute, from: entry.date)
        let hoursLeft = 23 - currentHour
        let minutesLeft = 59 - currentMinute
        let timeLeftText = "\(hoursLeft)h \(minutesLeft)m"

        VStack(alignment: .center, spacing: 12) {
            // Time grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 10) {
                ForEach(0..<24, id: \.self) { hour in
                    ZStack {
                        if hour < currentHour {
                            Circle()
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                                .frame(width: 12, height: 12)
                        } else if hour == currentHour {
                            ZStack {
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 12, height: 12)

                                Circle()
                                    .trim(from: CGFloat(currentMinute) / 60, to: 1)
                                    .stroke(Color.black, lineWidth: 12) // Same size as the circle
                                    .frame(width: 12, height: 12)
                                    .rotationEffect(.degrees(-90))
                            }
                        } else {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 12, height: 12)
                        }
                    }
                }
            }

            Text(timeLeftText)
                .font(.headline)
                .foregroundColor(.white)
        }
        .padding()
        .containerBackground(for: .widget) { Color.black }
    }
}

struct DaysWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        let calendar = Calendar.current
        let today = calendar.component(.weekday, from: entry.date)
        let daysLeftInWeek = 7 - today
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: entry.date) ?? 0
        let daysLeftInYear = (calendar.range(of: .day, in: .year, for: entry.date)?.count ?? 365) - dayOfYear

        VStack(alignment: .center, spacing: 12) {
            Text("\(daysLeftInWeek) days left this week")
                .font(.headline)
                .foregroundColor(.white)

            Text("\(daysLeftInYear) days left this year")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
        }
        .padding()
        .containerBackground(for: .widget) { Color.black }
    }
}

struct LifeWidget: Widget {
    let kind: String = "LifeWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            LifeWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("24-Hour Tracker")
        .description("Track how much time is left today.")
    }
}

struct DaysWidget: Widget {
    let kind: String = "DaysWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            DaysWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Days Tracker")
        .description("Track days left in the week and year.")
    }
}

struct LifeWidgetsBundle: WidgetBundle {
    var body: some Widget {
        LifeWidget()
        DaysWidget()
    }
}

// MARK: - Default Configuration Extension
extension ConfigurationAppIntent {
    static var defaultConfiguration: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀" // Example default value
        return intent
    }
}

// MARK: - Previews
struct LifeWidget_Previews: PreviewProvider {
    static var previews: some View {
        LifeWidgetEntryView(entry: SimpleEntry(date: .now, configuration: ConfigurationAppIntent.defaultConfiguration))
            .previewContext(WidgetPreviewContext(family: .systemSmall))

        DaysWidgetEntryView(entry: SimpleEntry(date: .now, configuration: ConfigurationAppIntent.defaultConfiguration))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
    
