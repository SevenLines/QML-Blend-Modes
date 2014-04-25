import QtQuick 2.0
import "Presentation"
import "Utils"
import "Lesson5"

OpacityTransitionPresentation {
    
    textColor: "white";
    
    SlideTitle {
        centeredText: "Смешивание изображений"
    }
    
    AlphaBlending { }   
    MaskBlending { }
    
    Addition { }   
    Subtract { }
    Difference { }
    MultiplyBlend { }
    Divide { }

    Lighten { }
    Darken { }
    
    HueBlend { }
    Saturation { }
    ColorBlend { }
    ValueBlend { }
    
    LinearLight { }
    LinearBurn { }
    ColorBurn { }
    
    LinearDodge { } 
    ColorDodge { }
    ScreenBlend { }

    OverlayBlend { }
    HardLight { }
    SoftLightBlend { }

    SlideTitle {
        centeredText: "Обход изображений"
    }
    
    Thresholding {    }
}
