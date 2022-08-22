pragma circom 2.0.3;

template Hash() {
  signal output out[512];

  for(var i = 0; i < 512; i++) {
    out[i] <== i \ 256;
  }
}

component main = Hash();
