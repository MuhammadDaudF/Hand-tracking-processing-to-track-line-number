import cv2
import mediapipe as mp
from pythonosc import udp_client

client = udp_client.SimpleUDPClient("127.0.0.1", 12000)

base_options = mp.tasks.BaseOptions(
    model_asset_path='hand_landmarker.task'
)
options = mp.tasks.vision.HandLandmarkerOptions(
    base_options=base_options,
    num_hands=1,
    min_hand_detection_confidence=0.7,
    min_tracking_confidence=0.5
)
detector = mp.tasks.vision.HandLandmarker.create_from_options(options)

cap = cv2.VideoCapture(0)
print("Kamera aktif. Tekan Q untuk keluar.")

while True:
    ret, frame = cap.read()
    if not ret:
        break

    frame = cv2.flip(frame, 1)
    rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
    mp_image = mp.Image(image_format=mp.ImageFormat.SRGB, data=rgb)

    result = detector.detect(mp_image)

    if result.hand_landmarks:
        # Ambil hanya titik 8 (ujung jari telunjuk)
        lm = result.hand_landmarks[0][8]
        client.send_message("/index", [lm.x, lm.y])

        # Gambar titik telunjuk di preview
        x = int(lm.x * frame.shape[1])
        y = int(lm.y * frame.shape[0])
        cv2.circle(frame, (x, y), 10, (0, 255, 255), -1)
        cv2.putText(frame, "Telunjuk", (x + 12, y),
                    cv2.FONT_HERSHEY_SIMPLEX, 0.6, (0, 255, 255), 2)

    cv2.imshow("Hand Tracking", frame)
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()