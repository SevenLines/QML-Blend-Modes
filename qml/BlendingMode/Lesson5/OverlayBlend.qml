import QtQuick 2.0

ImagesShaderComposition {
//    image2.source: "qrc:/lesson5/assets/Gradient.png"

    title: "Overlay"

    color: "#DDD"

    shaderMainFunc: "
    float x;
    bool above1 = false, above2 = false;
    vec4 activeImgFrag = vec4(0), inActiveImgFrag = vec4(0);
    x = qt_TexCoord0.x - image1X;
    x /= image1Width;
    if (x > 0.0 && x <= 1.0)  {
        above1 = true;
        activeImgFrag = texture2D(image1, vec2(x, qt_TexCoord0.y));
    }
    x = qt_TexCoord0.x - image2X;
    x /= image2Width;
    if (x > 0.0 && x <= 1.0)  {
        above2 = true;
        inActiveImgFrag = texture2D(image2, vec2(x, qt_TexCoord0.y));
    }
    if (above1 && above2) {
        float k = 2.0;
        if (inActiveImgFrag.r < 0.5) gl_FragColor.r = k * inActiveImgFrag.r * activeImgFrag.r;
        else gl_FragColor.r = 1.0 - k * (1.0 - inActiveImgFrag.r) * (1.0 - activeImgFrag.r);

        if (inActiveImgFrag.g < 0.5) gl_FragColor.g = k * inActiveImgFrag.g * activeImgFrag.g;
        else gl_FragColor.g = 1.0 - k * (1.0 - inActiveImgFrag.g) * (1.0 - activeImgFrag.g);

        if (inActiveImgFrag.b < 0.5) gl_FragColor.b = k * inActiveImgFrag.b * activeImgFrag.b;
        else gl_FragColor.b = 1.0 - k * (1.0 - inActiveImgFrag.b) * (1.0 - activeImgFrag.b);

        gl_FragColor.a = inActiveImgFrag.a;

        return;
    }
    if (above1) {
        gl_FragColor = activeImgFrag * vec4(image1Opacity);
        return;
    }
    if (above2) {
        gl_FragColor = inActiveImgFrag * vec4(image2Opacity);
        return;
    }
    gl_FragColor = vec4(0);
    "
}
