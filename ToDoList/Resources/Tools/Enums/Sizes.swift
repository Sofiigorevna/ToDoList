//
//  Sizes.swift
//  ToDoList
//
//  Created by sofiigorevna on 21.08.2025.
//

import Foundation

enum Sizes {
    
    enum Height {
        /// 1
        static let h001: CGFloat = 1
        /// 4
        static let h004: CGFloat = 4
        /// 12
        static let h012: CGFloat = 12
        /// 16
        static let h016: CGFloat = 16
        /// 20
        static let h020: CGFloat = 20
        /// 24
        static let h024: CGFloat = 24
        /// 28
        static let h028: CGFloat = 28
        /// 32
        static let h032: CGFloat = 32
        /// 40
        static let h040: CGFloat = 40
        /// 44
        static let h044: CGFloat = 44
        /// 52
        static let h052: CGFloat = 52
        /// 68
        static let h068: CGFloat = 68
        /// 80
        static let h080: CGFloat = 80
        /// 100
        static let h100: CGFloat = 100
        /// 150
        static let h150: CGFloat = 150
        /// 320
        static let h320: CGFloat = 320
        /// 377
        static let h377: CGFloat = 377
        /// 436
        static let h436: CGFloat = 436
    }
    
    enum Width {
        static let w001: CGFloat = 1
        /// 4
        static let w004: CGFloat = 4
        /// 16
        static let w016: CGFloat = 16
        /// 24
        static let w024: CGFloat = 24
        /// 28
        static let w028: CGFloat = 28
        /// 32
        static let w032: CGFloat = 32
        /// 46
        static let w046: CGFloat = 46
        /// 50
        static let w050: CGFloat = 50
        /// 52
        static let w052: CGFloat = 52
        /// 65
        static let w065: CGFloat = 65
        /// 80
        static let w080: CGFloat = 80
        /// 90
        static let w090: CGFloat = 90
        /// 160
        static let w160: CGFloat = 160
        /// 180
        static let w180: CGFloat = 180
        /// 250
        static let w250: CGFloat = 250
        /// 359
        static let w359: CGFloat = 359
    }
    
    enum Radius {
        // Pазмер радиуса рассчитывался из высоты 90px
        /// 0
        static let r000: CGFloat = 0
        /// 2
        static let r050: CGFloat = 2
        /// 4
        static let r100: CGFloat = 4
        /// 8
        static let r200: CGFloat = 8
        /// 12
        static let r300: CGFloat = 12
        /// 14
        static let r320: CGFloat = 14
        /// 16
        static let r400: CGFloat = 16
        /// 20
        static let r500: CGFloat = 20
        /// 24
        static let r600: CGFloat = 24
        /// 32
        static let r700: CGFloat = 32
        /// 48
        static let r800: CGFloat = 48
        /// 56
        static let r900: CGFloat = 56
        /// 64
        static let r110: CGFloat = 64
    }
    /// borderWidth = 0.5
    static let borderWidth: CGFloat = 1.5
    
    // swiftlint: disable all
    enum Spacing {
        /// 0 - Пустые промежутки
        static let zero: CGFloat = 0.0
        /// 2 - Поле между лейблом + вводом
        enum S2 {
            static let top: CGFloat = 2
            static let left: CGFloat = 2
            static let right: CGFloat = -2
            static let bottom: CGFloat = -2
        }
        /// 4 - Поле между лейблом + вводом
        enum S4 {
            static let top: CGFloat = 4
            static let left: CGFloat = 4
            static let right: CGFloat = -4
            static let bottom: CGFloat = -4
        }
        /// 8 - Поле между иконкой и текстом
        enum S8 {
            static let top: CGFloat = 8
            static let left: CGFloat = 8
            static let right: CGFloat = -8
            static let bottom: CGFloat = -8
        }
        /// 12 - Самый популярный размер
        enum S12 {
            static let top: CGFloat = 12
            static let left: CGFloat = 12
            static let right: CGFloat = -12
            static let bottom: CGFloat = -12
        }
        /// 14 - Самый популярный размер
        enum S14 {
            static let top: CGFloat = 14
            static let left: CGFloat = 14
            static let right: CGFloat = -14
            static let bottom: CGFloat = -14
        }
        /// 16 - Самый популярный размер
        enum S16 {
            static let top: CGFloat = 16
            static let left: CGFloat = 16
            static let right: CGFloat = -16
            static let bottom: CGFloat = -16
        }
        /// 20 - Самый популярный размер
        enum S20 {
            static let top: CGFloat = 20
            static let left: CGFloat = 20
            static let right: CGFloat = -20
            static let bottom: CGFloat = -20
        }
        /// 24 - Граница между секциями/элементами
        enum S24 {
            static let top: CGFloat = 24
            static let left: CGFloat = 24
            static let right: CGFloat = -24
            static let bottom: CGFloat = -24
        }
        /// 32 - Граница между секциями/элементами
        enum S32 {
            static let top: CGFloat = 32
            static let left: CGFloat = 32
            static let right: CGFloat = -32
            static let bottom: CGFloat = -32
        }
        /// 40 - Граница между секциями/элементами
        enum S40 {
            static let top: CGFloat = 40
            static let left: CGFloat = 40
            static let right: CGFloat = -40
            static let bottom: CGFloat = -40
        }
        /// 48 - Граница между секциями/элементами
        enum S48 {
            static let top: CGFloat = 48
            static let left: CGFloat = 48
            static let right: CGFloat = -48
            static let bottom: CGFloat = -48
        }
        /// 56 - Граница между секциями/элементами
        enum S56 {
            static let top: CGFloat = 56
            static let left: CGFloat = 56
            static let right: CGFloat = -56
            static let bottom: CGFloat = -56
        }
        /// 64 - Граница между секциями/элементами для больших размеров экранов
        enum S64 {
            static let top: CGFloat = 64
            static let left: CGFloat = 64
            static let right: CGFloat = -64
            static let bottom: CGFloat = -64
        }
    }
   // swiftlint:enable all
    enum Padding {
        static let zero: CGFloat = 0.0
        /// W - , H - , M - 0.25
        enum XXS {
            
            static let multiplier: CGFloat = 0.25
        }
        /// W - , H - , M - 0.3
        enum XS {
            
            static let multiplier: CGFloat = 0.3
        }
        /// W - , H - , M - 0.45
        enum S {
            
            static let multiplier: CGFloat = 0.45
        }
        /// W - , H - , M - 0.5
        enum M {
            
            static let multiplier: CGFloat = 0.5
        }
        /// W - , H - , M - 0.7
        enum L {
            
            static let multiplier: CGFloat = 0.7
        }
        /// W - , H - , M - 0.9
        enum XL {
            
            static let multiplier: CGFloat = 0.9
        }
        /// W - , H - , M - 1.0
        enum XXL {
            
            static let multiplier: CGFloat = 1.0
        }
    }
}
