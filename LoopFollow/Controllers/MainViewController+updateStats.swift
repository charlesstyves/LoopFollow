// LoopFollow
// MainViewController+updateStats.swift

import Foundation

extension MainViewController {
    func updateStats() {
        if bgData.count > 0 {
            var lastDayOfData = bgData
            let startOfToday = Calendar.current.startOfDay(for: Date()).timeIntervalSince1970
            
            var startIndex = 0
            while startIndex < bgData.count, bgData[startIndex].date < startOfToday {
                startIndex += 1
            }
            lastDayOfData = Array(bgData.dropFirst(startIndex))

            let stats = StatsData(bgData: lastDayOfData)

            statsDisplayModel.lowPercent = String(format: "%.1f%%", stats.percentLow)
            statsDisplayModel.inRangePercent = String(format: "%.1f%%", stats.percentRange)
            statsDisplayModel.highPercent = String(format: "%.1f%%", stats.percentHigh)
            statsDisplayModel.avgBG = Localizer.toDisplayUnits(String(format: "%.0f", stats.avgBG))

            statsDisplayModel.estA1CTitle = UnitSettingsStore.shared.glycemicMetricMode == .gmi ? "GMI:" : "Est. A1C:"
            if UnitSettingsStore.shared.glycemicOutputUnit == .mmolMol {
                statsDisplayModel.estA1C = String(format: "%.0f", stats.a1C)
            } else {
                statsDisplayModel.estA1C = String(format: "%.1f", stats.a1C)
            }

            if UnitSettingsStore.shared.variabilityMetricMode == .stdDeviation {
                statsDisplayModel.stdDevTitle = "Std Dev:"
                if UnitSettingsStore.shared.glucoseUnit == .mgdL {
                    statsDisplayModel.stdDev = String(format: "%.0f", stats.stdDev)
                } else {
                    statsDisplayModel.stdDev = String(format: "%.1f", stats.stdDev)
                }
            } else {
                statsDisplayModel.stdDevTitle = "CV:"
                statsDisplayModel.stdDev = String(format: "%.1f%%", stats.coefficientOfVariation)
            }

            statsDisplayModel.pieLow = Double(stats.percentLow)
            statsDisplayModel.pieRange = Double(stats.percentRange)
            statsDisplayModel.pieHigh = Double(stats.percentHigh)
        }
    }
}
