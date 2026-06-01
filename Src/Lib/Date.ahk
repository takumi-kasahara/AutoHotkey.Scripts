#Requires AutoHotkey v2.0

/**
 * @param {String} fmt
 * @param {String} [date=A_Now]
 * @returns {String}
 */
Date_ToString(fmt, date := A_Now) => FormatTime(date, fmt)
