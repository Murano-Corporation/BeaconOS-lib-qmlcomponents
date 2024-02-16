import QtQuick 2.12
import QtCharts 2.3

Item{
    id: compHealthDashboardContentGraphView

    property string valueUnits: "UNITS"
    property int stepCountMax: 10000
    property int stepCountCurrent: 0
    property var listDateTimes: []
    property double testDt: Date.now()
    property string testDtString: ""
    property int range: 10;
    property int testDtIncrement: 86400000;
    property int dateViewSpan: LiveGraphController.timespan
    //onDateViewSpanChanged: {
    //    console.log('Date View Span now: ' + dateViewSpan)
    //}

    property date dateMin: LiveGraphController.minTimestamp
    //onDateMinChanged: {
    //    console.log('Date min now: ' + dateMin)
    //}

    property date dateMax: LiveGraphController.maxTimestamp
    //onDateMaxChanged: {
    //    console.log('Date Max now: ' + dateMax)
    //}

    property double yValueMin: LiveGraphController.minYValue
    //onYValueMinChanged: {
    //    console.log("MinY now: " + yValueMin)
    //}

    property double yValueMax: LiveGraphController.maxYValue
    //onYValueMaxChanged: {
    //    console.log("MaxY now: " + yValueMax)
    //}


    property int devTimerInterval: 10

    signal forceHideGridListBtns()

    function testPoints_Initialize() {


        testDt = Date.now();
        testDtString = new Date().toLocaleString()

        //console.log("Test init: DateTime now" + testDt + " " + testDtString + " "+ Date.fromLocaleString(testDtString));
    }

    function testPoints_Step(){
        //console.log("Stepping")
        var randValue = (Math.random() * range)

        dateMax += devTimer.interval

        addPoint(dateMax, randValue)


        stepCountCurrent += 1

        if(stepCountCurrent >= stepCountMax)
        {
            //console.log("Test function complete")
        }
        else
            devTimer.start()
    }

    function addPoint(x, y)
    {
        //console.log('Adding point: ' + x + ":" + y)
        scatterSeries1.append(x,y)
        lineSeries1.append(x, y)

    }

    function removePoints(index, count)
    {
        //console.log('Removing points: ' + index + " - " + (index+count))
        scatterSeries1.removePoints(index, count)
        lineSeries1.removePoints(index, count)
    }

    function clear(){

        //console.log('Clearing graph')
        scatterSeries1.clear()
        lineSeries1.clear()
    }

    Component.onCompleted: {
        //testPoints_Initialize();
        //devTimer.start()
    }

    onVisibleChanged: {
        if(visible === true)
        {
            forceHideGridListBtns()
            LiveGraphController.signal_TargetDataChanged.connect(addPoint)
        } else {
            LiveGraphController.signal_TargetDataChanged.disconnect(addPoint)
        }
    }

    Connections{
        target: LiveGraphController

        function onSignal_RemovePoints(index, count){
            removePoints(index, count)
        }

        function onSignal_RemoveAllPoints(){
            clear()
        }
    }

    Timer{
        id: devTimer

        interval: compHealthDashboardContentGraphView.devTimerInterval

        onTriggered: {
            testPoints_Step()
        }
    }

    Rectangle{
        id: rectBg

        anchors{
            fill: parent
        }

        radius: 17

        color: "#1E273A"
    }

    ChartView{

        id: chart

        property color gridLineColor: "#4D4A5F"
        property color lineSeriesColor: "#5445CB"
        property color lineSeriesPointColor: "#B1A8FF"
        property real lineSeriesWidth: 5

        legend.visible: false




        anchors{
            fill: parent
        }

        //theme: ChartView.ChartThemeHighContrast

        backgroundColor: "transparent"

        title: ""
        antialiasing: true
        //animationDuration: compHealthDashboardContentGraphView.devTimerInterval
        //animationOptions: ChartView.SeriesAnimations

        DateTimeAxis {

            id: axisXDateTime

            format: "HH:mm:ss.zzz"
            tickCount: 2

            gridLineColor: chart.gridLineColor

            min: compHealthDashboardContentGraphView.dateMin
            max: compHealthDashboardContentGraphView.dateMax

            labelsFont:  Qt.font({family: 'Lato', weight: Font.Medium, pixelSize: 20})
            labelsColor: "White"
            labelsVisible: false
        }

        ValueAxis {
            id: axisYValue

            //labelFormat: "d"
            //tickCount: 3

            gridLineColor: chart.gridLineColor

            titleText: compHealthDashboardContentGraphView.valueUnits
            color: "White"
            titleBrush: color

            min: compHealthDashboardContentGraphView.yValueMin
            max: compHealthDashboardContentGraphView.yValueMax

            labelsFont:  Qt.font({family: 'Lato', weight: Font.Medium, pixelSize: 18})
            labelsColor: "White"
            //labelsVisible: false

        }



        LineSeries {
            id: lineSeries1

            visible: true

            //useOpenGL: true

            axisX: axisXDateTime
            axisY: axisYValue

            pointLabelsVisible: false
            pointsVisible: false
            //pointLabelsColor: chart.lineSeriesPointColor

            width: chart.lineSeriesWidth

            color: chart.lineSeriesColor

        }

        ScatterSeries {
            id: scatterSeries1



            //useOpenGL: true

            axisX: axisXDateTime
            axisY: axisYValue

            markerSize: 12
            markerShape: ScatterSeries.MarkerShapeCircle
            color: chart.lineSeriesPointColor
            borderWidth: 0
        }



    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
