class LCG {
  
  int m;
  int a;
  int c;
  
  int seed;

  LCG() {
    
    m = 134456;
    a = 8121;
    c = 28411;
  
    seed = m/2;
  }
  
  float generate() {
    seed = (a * seed + c) % m;
    return seed;
  }
  
  float generate(float start, float end) {
    float rand = generate();
    return map(rand, 0, m, start, end);
  }


}
