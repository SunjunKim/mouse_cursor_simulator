# mouse_cursor_simulator
A displayed cursor simulator, with parameters of mouse sampling fps, USB polling rate, and display frequency

## Assumptions
These assumption are made to purely compare the mouse-related parameters. Added latency from other system components may vary the result away from the simulation.
* The sensor captures the physical displacement perfectly.
* There's no overhead in signal processing and numeric computation.
* The mouse firmware (and maybe OS) keeps the fractional counts (truncated by integer conversion for a USB report) and accumulate it in the next USB report.
* There are absolutely no latency in OS and display.

# Run
Download Processing environment from https://processing.org/ and open ```mouse_cursor_simulator.pde``` on Processing.

# Parameters
Note that DPI doesn't matter, as the code assumes a perfect linear motion with perfect sensing capability (no flaw in the sensor, so any DPI works).
```java
// Human parameters
double internal_sampling_frequency = 20000.0;  // Mouse image sampling frequency, unit: Hz 
double usb_polling_frequency = 8000.0; // USB polling frequency, unit: Hz
double display_frequency = 320.0; // display frame per second, unit: Hz
double eye_retention_period = 150; // unit: ms
double eye_retention_frequency = 1000.0 / eye_retention_period; // an image presist in the eye (fps)
//double eye_retention_frequency = 60.0;   // alternatively, you can set the eye frequency directly

// Assume the noise is distributed linearly
double internal_sampling_jitter = 0.0; // unit: %
double usb_polling_jitter = 10.0; // unit: %
double display_polling_jitter = 10.0; // unit: %

boolean display_animation = false;
double time_multiplier = 1.0 / 10; // when do animation, 1.0 = realtime / 0.1 = 10x slower / 0.01 = 100x slower

// Movement profile
// unit: pixel
int sx = 20;  // start position x
int sy = 10;  // start position y
int ex = 980; // end position x
int ey = 80;  // end position y

float speed = 2000; // cursor movement speed, unit: pixel/second
```

# Some example values
* internal_sampling_frequency
  * PixART PMW3360: 12000 Hz
  * PixART PMW3390: 16000 Hz
  * Avango ADNS-3090: 6400 Hz
* polling_frequency
  * USB 2.0 supports 125, 250, 500, 1000 Hz
  * Some overclocked polling may use 2000 Hz, and up to 8000 Hz (Razer prototype)
* display_frequency
  * Typically 60 Hz
  * Faster monitors may have 120, 240, 360 Hz
  * You can simulate up to 1000 Hz
* eye_retention_period
  * I set this with 150 ms, but a reference is needed.
* display_animation (```true/false```)
  * if ```true```, the cursor will be animated with the given eye_retention_period.
  * if ```false```, the entire cursors will be displayed at once.
* time_multiplier
  * When doing animation, time is multiplied by this amount.
  * ex) 100x slower => 1.0 / **100**
