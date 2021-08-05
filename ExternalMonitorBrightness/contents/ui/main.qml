import QtQuick 2.4
import QtQuick.Layouts 1.1
import org.kde.plasma.components 2.0 as PlasmaComponents2
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0
import org.kde.kcoreaddons 1.0 as KCoreAddons
import org.kde.kquickcontrolsaddons 2.0

Item {
    
    id: controller
    
    property int current_brightness: 0
    readonly property int brightness_step_size: 10
    readonly property int i2c_device_bus_id: 3
    
    Component.onCompleted: {
        get_brightness.exec()
    }
    
    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation
    Plasmoid.title: i18n("External Monitor Brightness")
    Plasmoid.toolTipSubText: i18n("Brightness control for external monitor")
    
    PlasmaCore.DataSource {
        id: get_brightness
        engine: "executable"
        connectedSources: []
        
        onNewData: {
            var exitCode = data["exit code"]
            var exitStatus = data["exit status"]
            var stdout = data["stdout"]
            var stderr = data["stderr"]
            disconnectSource(sourceName) // cmd finished
            console.log("stdout " + stdout)
            //console.log("stderr " + stderr)
            //console.log("exit code " + exitCode)
            if (exitCode == 0) {
                controller.current_brightness = stdout
                console.log("Current Brightness = " + stdout)
            }
        }
        function exec() {
            connectSource("ddcutil --noverify --sleep-multiplier 0.1 --bus " + controller.i2c_device_bus_id + " getvcp 10 | cut -d '=' -f 2 | cut -d ',' -f 1 | sed 's/^ *//g'")                    
        }
    }
    
    PlasmaCore.DataSource {
        id: bash
        engine: "executable"
        connectedSources: []
        
        onNewData: {
            // -- only enable the following for debugging
            // var exitCode = data["exit code"]
            // var exitStatus = data["exit status"]
            // var stdout = data["stdout"]
            // var stderr = data["stderr"]
            // exited(sourceName, exitCode, exitStatus, stdout, stderr)
            disconnectSource(sourceName)
        }
        function exec(cmd) {
            if (cmd) {
                connectSource(cmd)                    
            }
        }
        //signal exited(string cmd, int exitCode, int exitStatus, string stdout, string stderr)
    }
    
    function set_brightness(value){
        var cmd = "ddcutil --noverify --sleep-multiplier 0.1 --bus 3 setvcp 10 " + value
        bash.exec(cmd)
        controller.current_brightness = value
    }
    
    
    Plasmoid.compactRepresentation: PlasmaCore.IconItem {
        source: Qt.resolvedUrl("../images/brightness.png")
        active: mouseArea.containsMouse
        scale: 0.6
        
        
        MouseArea {
            id: mouseArea
            
            property int wheelDelta: 0
            property bool isExpanded
            
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton | Qt.MiddleButton
            onClicked: {
                if (mouse.button == Qt.LeftButton) {
                    plasmoid.expanded = !plasmoid.expanded;
                    if (!isExpanded){
                        isExpanded = !isExpanded
                    }
                    else {
                        isExpanded = !isExpanded
                    }
                }
            }
            
            onWheel: {
                var delta = wheel.angleDelta.y || wheel.angleDelta.x;
                wheelDelta += delta;
                // Magic number 120 for common "one click"
                // See: https://qt-project.org/doc/qt-5/qml-qtquick-wheelevent.html#angleDelta-prop
                while (wheelDelta >= 120) {
                    wheelDelta -= 120;
                    set_brightness(controller.current_brightness + 10)
                }
                while (wheelDelta <= -120) {
                    wheelDelta += 120;
                    set_brightness(controller.current_brightness - 10)
                }
            }
        }
    }
    
    
    Plasmoid.fullRepresentation: PlasmaComponents3.Slider {
        height: 25
        width: 100
        id: slider
        visible: true
        focus: true
        hoverEnabled: true
        handle: Item {}
        from: 0
        to: 100
        value: controller.current_brightness
        stepSize: controller.brightness_step_size
        live: false
        snapMode: SnapAlways
        orientation: Qt.Vertical
        //wheelEnabled: false // don't enable mousewheel until initial value is read
        
        onMoved: {
            //slider.wheelEnabled = false // disable mouse wheel until the brightness is set
            set_brightness(value)
        }
    }
    
}
