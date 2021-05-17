//
//  DateFormatter+Extension.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/16/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation

extension DateFormatter {

    static let standardFormatter: DateFormatter = {

        let calendar = Calendar.current
        let locale = NSLocale.system

        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.calendar = calendar
        formatter.timeZone = NSTimeZone.system

        return formatter
    }()

    static let currentZoneFormatter: DateFormatter = {

        let calendar = Calendar.current
        let locale = Locale.current

        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.calendar = calendar

        return formatter
    }()

}
