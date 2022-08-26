pragma circom 2.0.3;

include "../../circuits/curve.circom";

template AggregateKeys(n) {
  var J = 2;
  var K = 7;
  signal input points[n][J][K];

  signal output out[J][K];

  component ellipticCurveAdd[n - 1];

  ellipticCurveAdd[0] = EllipticCurveAdd(55, 7, 0, 4, [35747322042231467, 36025922209447795, 1084959616957103, 7925923977987733, 16551456537884751, 23443114579904617, 1829881462546425]);
  ellipticCurveAdd[0].aIsInfinity <== 0;
  ellipticCurveAdd[0].bIsInfinity <== 0;
  for(var j = 0; j < J; j++) {
    for(var k = 0; k < K; k++) {
      ellipticCurveAdd[0].a[j][k] <== points[0][j][k];
      ellipticCurveAdd[0].b[j][k] <== points[1][j][k];
    }
  }

  for(var i = 1; i < n - 1; i++){
    ellipticCurveAdd[i] = EllipticCurveAdd(55, 7, 0, 4, [35747322042231467, 36025922209447795, 1084959616957103, 7925923977987733, 16551456537884751, 23443114579904617, 1829881462546425]);
    ellipticCurveAdd[i].aIsInfinity <== 0;
    ellipticCurveAdd[i].bIsInfinity <== 0;
    for(var j = 0; j < J; j++) {
      for(var k = 0; k < K; k++) {
        ellipticCurveAdd[i].a[j][k] <== ellipticCurveAdd[i - 1].out[j][k];
        ellipticCurveAdd[i].b[j][k] <== points[i + 1][j][k];
      }
    }
  }

  for(var j = 0; j < J; j++){
    for(var k = 0; k < K; k++) {
      out[j][k] <== ellipticCurveAdd[n - 2].out[j][k];
    }
  }
}

component main = AggregateKeys(12);

