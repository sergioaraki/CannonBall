import bb.cascades 1.0
import QtMobility.sensors 1.2
import bb.system 1.0
import bb.multimedia 1.0

Page {
    actionBarVisibility: ChromeVisibility.Hidden
    property int tiltAngle: 0
    property int dist
    function mensajePopup(mensaje){
        toast.body = mensaje;
        toast.show();
    }
    function actualizaDistancia(){
        objetivo.text = "Objetivo: "+dist+" m";
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
                animacion.play();
                sound.play();
                var g = 9.8;
                var radianes = tiltAngle * (0.017);
                var distance = Math.round(((Math.round(velocidad.value)*Math.round(velocidad.value))*(2*(Math.sin(radianes))*(Math.cos(radianes))))/g);
                distancia.text= "Disparo: " + distance + " m";
                var acerto = false;
                if (distance >= dist-5 && distance <= dist+5) {
                    acerto = true;
                }
                server.postMessage(acerto);
                var mensaje = "Pruebe de nuevo"
                if (acerto){
                    mensaje = "Felicitaciones!"
                }
                mensajePopup(mensaje);
            }
        }
        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            Label {
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 1
                }
                id: objetivo
                horizontalAlignment: HorizontalAlignment.Center
            }
            Label {
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 1
                }
                id: distancia
                horizontalAlignment: HorizontalAlignment.Center
            }
        }
        Divider {
            
        }
        ImageView {
            imageSource: "images/cannon.png"
            horizontalAlignment: HorizontalAlignment.Center
            animations: [
                SequentialAnimation {
                    id: animacion
                    animations: [
                        TranslateTransition {
                            id: atras
                            toX: -75
                            duration: 250
                            easingCurve: StockCurve.QuinticOut
                        },
                        TranslateTransition {
                            id: adelante
                            toX: 0
                            duration: 900
                            easingCurve: StockCurve.Linear
                        }
                    ]
                }
            ]
        }
        WebView {
            url: "local:///assets/webview/cannon.html"
            id: server
            onMessageReceived: {
                if (message.data.match('dist')) {
                    var distance = message.data.split('-')[1];
                    dist = distance;
                    var mensaje = "La bandera se encuentra a " + dist;
                    mensajePopup(mensaje);
                    actualizaDistancia();
                }
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
