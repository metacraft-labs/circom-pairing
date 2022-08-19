pragma circom 2.0.3;

include "../../node_modules/circomlib/circuits/sha256/sha256.circom";

template HashTwo() {
  signal input in[2][256];

  signal output out[256];

  component sha256 = Sha256(512);

  for(var i = 0; i < 512; i++) {
    sha256.in[i] <== in[i \ 256][i % 256];
  }

  for(var i = 0; i < 256; i++) {
    out[i] <== sha256.out[i];
  }
}

template HashTreeRoot() {
  var N = 2;
  signal input points[N][384];

  signal output out[256];

  component leaves[N];

  for(var i = 0; i < N; i++) {
    leaves[i] = Sha256(512);
    for(var j = 0; j < 384; j++) {
      leaves[i].in[j] <== points[i][j];
    }

    for(var j = 384; j < 512; j++) {
      leaves[i].in[j] <== 0;
    }
  }

  component hashers[N - 1];

  for(var i = 0; i < N - 1; i++) {
    hashers[i] = HashTwo();
  }

  for(var i = 0; i < N / 2; i++) {
    for(var j = 0; j < 256; j++) {
      hashers[i].in[0][j] <== leaves[i * 2].out[j];
      hashers[i].in[1][j] <== leaves[i * 2 + 1].out[j];
    }
  }

  var k = 0;
  for(var i = N / 2; i < N - 1; i++) {
    for(var j = 0; j < 256; j++) {
      hashers[i].in[0][j] <== hashers[k*2].out[j];
      hashers[i].in[1][j] <== hashers[k*2 + 1].out[j];
    }
    k++;
  }


  for(var i = 0; i < 256; i++) {
    out[i] <== hashers[N - 2].out[i];
  }
}

component main = HashTreeRoot();