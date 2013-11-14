import bb.cascades 1.0
import QtMobility.sensors 1.2
import bb.system 1.0
import bb.multimedia 1.0

Page {
    actionBarVisibility: ChromeVisibility.Hidden
    property int tiltAngle: 0
    function mensajePopup(mensaje){
        toast.body = mensaje;
        toast.show();
    }
    Container {
        layout: StackLayout {
        }
        topPadding: 20
        leftPadding: 20
        rightPadding: 20
        attachedObjects: [
            RotationSensor {
                active: true
                onReadingChanged: {
                    // When we tilt the device backwards, we add a sense of stiffness of 8 degrees 
                    // before it actually changes the tiltAngle property (a.k.a. dead zone)
                    var deadZoneAngle = 8
                    
                    if (tiltAngle >= reading.x && tiltAngle > (reading.x + deadZoneAngle)) {
                        tiltAngle = reading.x;
                    } 
                    else if (tiltAngle < reading.x) {
                        tiltAngle = reading.x;
                    }
                }
            
            }
        ]
        Label {
            id: lblVelocidad
            text: "Velocidad (m/s)"
        }
        Slider {
            id: velocidad
            toValue: 100.0
            onImmediateValueChanged: {
                            lblVelocidad.text = "Velocidad "+Math.round(immediateValue)+" m/s"
            }
        }
        Divider {
            
        }
        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            Label {
                text: "Ángulo"
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 2
                }
            }
            Label {
                text: tiltAngle + "°"
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 3
                }
                textStyle.base: SystemDefaults.TextStyles.BigText
            }
        }
        Button {
            text: "Disparar"
            horizontalAlignment: HorizontalAlignment.Fill
            onClicked: {
                sound.play();
                var g = 9.8;
                var radianes = tiltAngle * (0.017);
                var dist = Math.round(((Math.round(velocidad.value)*Math.round(velocidad.value))*(2*(Math.sin(radianes))*(Math.cos(radianes))))/g);
                distancia.text= dist + " m";
                server.postMessage(dist);
            }
        }
        Label {
            id: distancia
            horizontalAlignment: HorizontalAlignment.Center
            textStyle.base: SystemDefaults.TextStyles.BigText
        }
        Divider {
            
        }
        WebView {
            url: "local:///assets/cannon.html"
            id: server
            onMessageReceived: {
                mensajePopup(message.data);
            }
            settings.background: Color.Transparent 
            maxWidth: 680
        }
    }
    attachedObjects: [
        SystemToast {
            id: toast
        },
        MediaPlayer {
            id: sound
            sourceUrl: "sounds/bang.wav"
        }      
    ]
    onCreationCompleted: {
        Application.mainWindow.screenIdleMode = 1;
    }
}
