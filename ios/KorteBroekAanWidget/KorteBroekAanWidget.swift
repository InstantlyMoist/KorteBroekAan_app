//
//  KorteBroekAanWidget.swift
//  KorteBroekAanWidget
//
//  Created by Kyllian Warmerdam on 23/06/2022.
//

private let widgetGroupId = "group.kortebroekaan"

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), imageName: "unknown", configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let data = UserDefaults.init(suiteName: widgetGroupId)
        
        let entry = SimpleEntry(date: Date(), imageName: data?.string(forKey: "imageName") ?? "unknown" , configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        getSnapshot(for: configuration, in: context) { (entry) in
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let imageName: String
    let configuration: ConfigurationIntent
}


struct KorteBroekAanWidgetEntryView : View {
    var entry: Provider.Entry
    let data = UserDefaults.init(suiteName:widgetGroupId)
    
    var body: some View {
        ZStack {
            Color(entry.imageName)
                .ignoresSafeArea()
            Image(entry.imageName + "-man")
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(16)
        }
        
    }
}

@main
struct KorteBroekAanWidget: Widget {
    let kind: String = "KorteBroekAanWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            KorteBroekAanWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Kortebroekaan")
        .description("Laat zien of je een korte broek aan kunt doen!")
    }
}

struct KorteBroekAanWidget_Previews: PreviewProvider {
    static var previews: some View {
        KorteBroekAanWidgetEntryView(entry: SimpleEntry(date: Date(), imageName: "unknown" ,configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
