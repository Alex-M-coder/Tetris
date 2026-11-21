# 🕹️ Tetris Neon - Sincronía Cyberpunk

Una implementación moderna, fluida y visualmente impactante del clásico juego arcade **Tetris** utilizando tecnologías web nativas. Diseñado con una estética retro-cyberpunk y synthwave que resalta los bloques mediante colores neón vibrantes, efectos de brillo dinámicos y transiciones fluidas.

---

## 🎨 Características Destacadas

*   **Estética Neon Synthwave:** Colores HSL adaptados que brillan en la oscuridad, acompañados de un fondo de rejilla cibernética y un filtro opcional que simula las pantallas analógicas CRT.
*   **Proyección Fantasma (Ghost Piece):** Muestra de forma translúcida dónde caerá la pieza actual para permitir una planificación táctica de movimientos.
*   **Mecánica de Reserva (Hold Block):** Guarda una pieza presionando la tecla `C` o `Shift` para usarla estratégicamente en cualquier momento del juego.
*   **Efectos Dinámicos:** Partículas interactivas que explotan al completar líneas, sacudidas de pantalla al bloquear con fuerza o limpiar filas, y fogonazos de luz al realizar un *Tetris* (4 líneas a la vez).
*   **Síntesis de Audio Web API:** Todos los sonidos (giros, caídas, subida de nivel, game over, líneas completadas) se generan en tiempo real de forma algorítmica por el navegador, garantizando rendimiento instantáneo sin recurrir a recursos multimedia externos pesados.
*   **Progresión Dinámica:** La velocidad del juego aumenta conforme subes de nivel (cada 10 líneas despejadas).
*   **Puntuaciones Altas:** Conserva tu puntuación récord en la memoria local del navegador (`localStorage`).

---

## 🎮 Controles de Juego

### 💻 PC (teclado)

| Tecla / Combinación | Acción |
| :--- | :--- |
| **`A` / `D` / `Flecha Izquierda / Derecha`** | Mover la pieza hacia los lados |
| **`W` / `Flecha Arriba`** | Rotar la pieza (incluye sistema de acomodación de paredes / Wall Kick) |
| **`S` / `Flecha Abajo`** | Caída suave (avanza más rápido e incrementa puntos) |
| **`Espacio (Space)`** | Caída rápida instantánea (bloquea la pieza inmediatamente con sacudida de pantalla) |
| **`C` / `Shift`** | Guardar la pieza actual en la zona de reserva / Intercambiar con la guardada |
| **`P`** | Pausar y reanudar la simulación |

### 📱 Móvil / Tablet (táctil)

| Gesto / Botón | Acción |
| :--- | :--- |
| **Tocar el tablero** | Rotar |
| **Deslizar ◀ ▶ sobre el tablero** | Mover (una celda por cada bloque deslizado) |
| **Arrastrar ▼** | Caída suave |
| **Deslizar ▼ rápido** | Caída rápida |
| **Deslizar ▲** | Guardar pieza (Hold) |
| **Botones ◀ ▼ ▶** | Se pueden mantener pulsados (auto-repetición DAS/ARR como en el teclado) |
| **Botones GUARDAR / ROTAR / SOLTAR** | Guardar, rotar y caída rápida |

Además: vibración háptica, pausa automática al salir de la App o girar el móvil, y diseño a pantalla completa adaptado a notch / barras del sistema.

---

## 📲 App instalable (PWA) para móvil y PC

El juego es una **Progressive Web App**: se instala como una aplicación nativa (icono propio, ventana sin barra del navegador) y **funciona sin conexión** gracias al Service Worker.

| Plataforma | Cómo instalar |
| :--- | :--- |
| **Android (Chrome)** | Pulsa **📲 INSTALAR APP** en la pantalla de inicio del juego, o menú ⋮ → *Instalar aplicación* |
| **iPhone / iPad (Safari)** | Botón **Compartir** → *Añadir a pantalla de inicio* |
| **PC (Chrome / Edge)** | Pulsa **📲 INSTALAR APP** o el icono de instalar en la barra de direcciones |

> ⚠️ La instalación y el modo offline requieren servir el juego por **HTTPS** (o `localhost`). Abriendo `index.html` con doble clic el juego funciona, pero no se puede instalar.

Para publicarlo gratis con HTTPS puedes usar **GitHub Pages**, **Netlify** o **Cloudflare Pages** (basta con subir la carpeta `Tetris-v1`).

> 🔁 Si modificas archivos del juego, sube la versión `CACHE_VERSION` en `sw.js` para que los usuarios reciban la actualización.

---

## 🛠️ Estructura del Código

El juego está diseñado siguiendo estándares limpios y modulares sin dependencias externas:

```plaintext
Tetris-v1/
├── index.html            # Estructura del juego, pantallas flotantes y HUD glassmorphism
├── manifest.webmanifest  # Manifiesto de la App (nombre, iconos, colores, orientación)
├── sw.js                 # Service Worker: caché offline e instalación
├── css/
│   └── styles.css        # Paleta neón, overlays, diseño PC y diseño móvil a pantalla completa
├── js/
│   ├── game.js           # Bucle de juego, colisiones, partículas, escalado adaptable y gestos táctiles
│   ├── audio.js          # Motor sintetizador de audio (Oscillators, Envelopes, Gain nodes)
│   └── app.js            # Registro del Service Worker y botón de instalación
├── assets/icons/         # Iconos de la App (192, 512, maskable, Apple, favicon)
├── tools/
│   └── generar-iconos.ps1  # Regenera los iconos PNG
└── README.md
```

---

## 🚀 Cómo Ejecutar el Juego

1.  Abre una terminal y navega hasta la carpeta del proyecto:
    ```bash
    cd Proyectos_de_juegos/Tetris-v1
    ```
2.  Sírvelo con un servidor local (necesario para instalarlo como App):
    ```bash
    python -m http.server 8080
    # o bien
    npx http-server -p 8080
    ```
    Abre **http://localhost:8080** en el navegador.
3.  **Para probarlo en tu móvil** (misma red Wi-Fi): abre `http://IP-DE-TU-PC:8080`. Para instalarlo en el móvil necesitas HTTPS, así que lo más cómodo es publicarlo (GitHub Pages / Netlify).
4.  ¡Pulsa en **"INICIAR OPERACIÓN"** para empezar a jugar!
