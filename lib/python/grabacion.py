import sounddevice as sd
import soundfile as sf
import speech_recognition as sr
import pyttsx3
import keyboard

engine = pyttsx3.init()

archivo_salida = "grabacion.wav"
fs = 44100
grabacion = None
grabando = False  # Variable para indicar si se está realizando una grabación

def grabar_audio(language='es'):
    try:
        global grabacion, grabando
        # Grabar audio hasta que se presione la tecla "2"
        print("Grabando audio... (Presiona '2' para detener)")
        grabacion = sd.rec(int(fs * 10), samplerate=fs, channels=1)
        grabando = True
        while grabando:
            if keyboard.is_pressed('2'):
                grabando = False
        guardar()
        print("¡Grabación finalizada y guardada en", archivo_salida, "!")
        transcribir_audio(language)
    except Exception as e:
        print("Error al grabar y transcribir el audio:", str(e))
        return None

def guardar():
    global grabacion
    # Guardar la grabación en un archivo WAV
    print("Guardando audio...")
    sf.write(archivo_salida, grabacion, fs)

def transcribir_audio(language='es'):
    global archivo_salida
    # Cargar el archivo de audio grabado
    audio = sr.AudioFile(archivo_salida)

    # Inicializar el reconocedor de voz
    r = sr.Recognizer()

    # Transcribir el audio
    with audio as source:
        audio_data = r.record(source)
        texto = r.recognize_google(audio_data, language=language)

    print("Texto transcribido:", texto)
    sintetizar_voz(texto, language)

def sintetizar_voz(texto, language='es'):
    # Configurar el motor de síntesis de voz
    engine.setProperty('rate', 150)  # Velocidad de habla
    engine.setProperty('volume', 1.0)  # Volumen de habla

    # Configurar el idioma
    voices = engine.getProperty('voices')
    for voice in voices:
        if language in voice.languages:
            engine.setProperty('voice', voice.id)
            break

    # Sintetizar el texto en voz
    engine.say(texto)
    engine.runAndWait()

def iniciar_grabacion():
    print("¡Grabación iniciada!")
    grabar_audio()

def detener_grabacion():
    global grabando
    print("Deteniendo la grabación...")
    grabando = False

def main():
    print("Presiona la tecla '1' para iniciar la grabación...")
    keyboard.wait('1')
    iniciar_grabacion()

    print("Presiona la tecla '2' para detener la grabación...")
    keyboard.wait('2')
    detener_grabacion()

if __name__ == '__main__':
    main()

