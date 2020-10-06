int internal_sampling_frequency = 12000;
int polling_frequency = 8000;
int display_frequency = 240;

int eye_persistent_frequency = 16; // an image presist in the eye

// unit: pixel
int sx = 20;  // start position x
int sy = 10;  // start position y
int ex = 980; // end position x
int ey = 70;  // end position y

float speed = 2000; // pixel/second

// ================== INTERNAL VARIABLES =====================

float displacement = sqrt((sx-ex)*(sx-ex) + (sy-ey)*(sy-ey)); // unit: pixel
float time_taken = displacement / speed; // unit: second

float sample_interval = 1.0 / float(internal_sampling_frequency); // unit: second
float polling_interval = 1.0 / float(polling_frequency);  // unit: second
float display_interval = 1.0 / float(display_frequency);  // unit: second


//int num_sampled_points = floor(time_taken * internal_sampling_frequency);
//int num_polling_request = floor(time_taken * polling_frequency);
int num_cursor_display = floor(time_taken * display_frequency); // expected number of cursors displayed
int[] xs = new int[num_cursor_display+100]; // additional +100 sized buffer, just in case
int[] ys = new int[num_cursor_display+100];

int num_cursor_persist = ceil(float(display_frequency) / float(eye_persistent_frequency));

// counters
int N_sample = 0;
int N_poll = 0;
int N_display = 0;

void setup()
{
  size(1000, 100);
  frameRate(5);
  println(time_taken);
  //println(num_sampled_points);
  //println(num_polling_request);
  println(num_cursor_display);

  
  float accum_poll_x = 0;  // accumulated x to be displayed
  float accum_poll_y = 0;  // accumulated y to be displayed
  
  float accum_disp_x = 0;
  float accum_disp_y = 0;
  
  float last_poll = 0.0;
  float last_disp = 0.0;
  
  xs[0] = sx;
  ys[0] = sy;
  
  // for the movement time:
  // time ticks by the sampling interval
  for(float time = 0.0; time <= time_taken; time += sample_interval)
  {    
    // when polling interval is due, add the detected displacements to the accumulated displacement (done within OS) 
    if(last_poll + polling_interval <=time){      
      float segment_start_x = interpolate(sx, ex, time_taken, last_poll); 
      float segment_start_y = interpolate(sy, ey, time_taken, last_poll);
      float segment_end_x = interpolate(sx, ex, time_taken, time); 
      float segment_end_y = interpolate(sy, ey, time_taken, time);
      
      accum_poll_x += segment_end_x - segment_start_x;
      accum_poll_y += segment_end_y - segment_start_y;
      
      last_poll = time;
      N_poll++;  
    }
    
    // when display interval is due, send the accumulated displacement to the screen. Assume internal floating point calculatin within OS    
    if(last_disp + display_interval <= time) {
      int count_x = floor(accum_poll_x);
      int count_y = floor(accum_poll_y);
      
      // display works in integer pixels
      N_display++;
      xs[N_display] = xs[N_display-1] + count_x;
      ys[N_display] = ys[N_display-1] + count_y;
      
      // keep the residue
      accum_poll_x -= count_x;
      accum_poll_y -= count_y;
      
      last_disp = time;
    }
    
    N_sample++;  
    
  }
  println(N_sample);
  println(N_poll);
  println(N_display);
}

int window = 0;

void draw()
{
  background(127);
  strokeWeight(1);
    
    
  float opacity = 0.0;
  for(int i=window;i<min(N_display, window+num_cursor_persist);i++)
  {
    opacity += 1.0 / num_cursor_persist;
    
    stroke(0, opacity*255);
    fill(255, opacity*255);
    
    draw_cursor(xs[i], ys[i]);
  }  
  
  window++;
  if(window == N_display)
  {
    window = 0;
  }
}

float interpolate(int start, int end, float total, float i)
{
  int gap = end - start;
  float ratio = i / total;
  
  return float(gap)*ratio+float(start);
}

void draw_cursor(int xpos, int ypos)
{
  pushMatrix();
  translate(xpos, ypos);
  beginShape();
  vertex(0, 0);
  vertex(0, 16);
  vertex(4, 12);
  vertex(8, 21);
  vertex(10, 20);
  vertex(6, 11);
  vertex(11, 10);
  vertex(0,0);
  endShape();
  popMatrix();
}
