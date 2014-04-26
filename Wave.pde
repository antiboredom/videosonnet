class Wave {
  float t, f, a, o;
  float val;

  Wave(float _t, float _f, float _a) {
    t = _t;
    f = _f;
    a = _a;
    o = 0;
  }

  Wave(float _t, float _f, float _a, float _o) {
    t = _t;
    f = _f;
    a = _a;
    o = _o;
  }

  float  wave  () {
    t+=f;
    val = sin(t)*a + o;
    return val;
  }
}

