import QtQuick 2.15

Screen__BASE {
id: screen_Raptor_Root

screenName: "Raptor"

Item{
    id: areaContents

    anchors.fill: parent
}

Loader{
    id: loaderDelta

    active: isDelta
    asynchronous: true
    anchors.fill: areaContents


    sourceComponent: Screen_Raptor_Delta {
        id: screen_Raptor_Delta
    }
}

Loader{
    id: loaderOmega

    active: !isDelta
    asynchronous: true
    anchors.fill: areaContents

    sourceComponent: Screen_Raptor_Omega {
        id: screen_Raptor_Omega
    }
}


}
