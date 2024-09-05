// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<8x9xcomplex<f32>> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %0 = call @inputs() : () -> tensor<8x9xcomplex<f32>>
    %1 = call @expected() : () -> tensor<8x9xcomplex<f32>>
    %2 = call @cummax(%0) : (tensor<8x9xcomplex<f32>>) -> tensor<8x9xcomplex<f32>>
    stablehlo.custom_call @check.expect_close(%2, %1) {has_side_effect = true} : (tensor<8x9xcomplex<f32>>, tensor<8x9xcomplex<f32>>) -> ()
    return %2 : tensor<8x9xcomplex<f32>>
  }
  func.func private @inputs() -> (tensor<8x9xcomplex<f32>> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<[[(3.84222937,-4.07376957), (-3.30720425,0.605341613), (1.99374831,-3.19304276), (3.83929539,-1.344733), (2.0501442,-3.83116722), (1.6301744,-2.6855197), (-2.88932061,1.5100981), (3.21203566,-2.45272684), (-4.32157183,3.12895322)], [(-3.03558159,-2.6696353), (-0.382023901,0.671883225), (0.931879162,5.05616665), (1.31878424,2.40079951), (0.0779306069,-3.73457646), (0.628998458,0.302356631), (-3.43190384,-6.13689422), (5.26664162,2.72741795), (1.70205581,-1.19082344)], [(0.710693598,-4.33593798), (-0.60440135,-3.77884412), (-0.851978898,1.83554709), (-1.48068583,1.31313956), (4.78783703,1.86462414), (-2.33403516,-1.10453033), (-2.67092705,2.43121219), (-3.99382687,1.0775677), (2.82997942,3.69945884)], [(-0.0153324269,-3.54470706), (1.65100336,4.80288601), (-3.45478463,-2.35550547), (5.13276625,2.2803936), (-3.40742254,-4.28600407), (2.06573081,0.426943481), (0.356091857,-3.08461022), (-3.30367374,-4.14340496), (2.2871809,-7.61976909)], [(3.2982285,-3.60542154), (0.382862747,-1.62242818), (-0.465912342,-0.368292779), (1.7490238,-1.731150e+00), (3.72079039,1.0512768), (1.82980776,-1.50235641), (-3.91470528,3.50378704), (0.461831957,-5.41343927), (2.78303385,-0.727609932)], [(4.45372057,2.69162941), (-0.525085866,2.89799356), (2.6164403,0.675925255), (-1.0637033,-4.14222622), (-3.01876664,1.9756186), (-1.20045018,-8.32564449), (0.653494536,-5.31291437), (-5.22536182,0.704468727), (-0.534620523,-2.82011628)], [(0.910863518,-3.03815103), (-5.168390e+00,2.11674356), (2.64701581,-1.80042851), (-1.33624268,0.584626615), (-4.59208107,2.98334336), (-1.68833625,-2.73364973), (1.43864465,4.8553195), (-3.55258083,-3.15565109), (1.039433,3.85579777)], [(-1.98785472,2.9352026), (-1.33995163,-1.30169809), (-0.792686104,-2.695900e+00), (0.475819439,-0.00471692951), (-1.13181674,1.47762156), (-0.215680927,-1.69344175), (2.03197026,4.65510082), (2.78899026,1.10491705), (1.84961784,-0.64051038)]]> : tensor<8x9xcomplex<f32>>
    return %cst : tensor<8x9xcomplex<f32>>
  }
  func.func private @expected() -> (tensor<8x9xcomplex<f32>> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<[[(3.84222937,-4.07376957), (-3.30720425,0.605341613), (1.99374831,-3.19304276), (3.83929539,-1.344733), (2.0501442,-3.83116722), (1.6301744,-2.6855197), (-2.88932061,1.5100981), (3.21203566,-2.45272684), (-4.32157183,3.12895322)], [(3.84222937,-4.07376957), (-0.382023901,0.671883225), (1.99374831,-3.19304276), (3.83929539,-1.344733), (2.0501442,-3.83116722), (1.6301744,-2.6855197), (-2.88932061,1.5100981), (5.26664162,2.72741795), (1.70205581,-1.19082344)], [(3.84222937,-4.07376957), (-0.382023901,0.671883225), (1.99374831,-3.19304276), (3.83929539,-1.344733), (4.78783703,1.86462414), (1.6301744,-2.6855197), (-2.67092705,2.43121219), (5.26664162,2.72741795), (2.82997942,3.69945884)], [(3.84222937,-4.07376957), (1.65100336,4.80288601), (1.99374831,-3.19304276), (5.13276625,2.2803936), (4.78783703,1.86462414), (2.06573081,0.426943481), (0.356091857,-3.08461022), (5.26664162,2.72741795), (2.82997942,3.69945884)], [(3.84222937,-4.07376957), (1.65100336,4.80288601), (1.99374831,-3.19304276), (5.13276625,2.2803936), (4.78783703,1.86462414), (2.06573081,0.426943481), (0.356091857,-3.08461022), (5.26664162,2.72741795), (2.82997942,3.69945884)], [(4.45372057,2.69162941), (1.65100336,4.80288601), (2.6164403,0.675925255), (5.13276625,2.2803936), (4.78783703,1.86462414), (2.06573081,0.426943481), (0.653494536,-5.31291437), (5.26664162,2.72741795), (2.82997942,3.69945884)], [(4.45372057,2.69162941), (1.65100336,4.80288601), (2.64701581,-1.80042851), (5.13276625,2.2803936), (4.78783703,1.86462414), (2.06573081,0.426943481), (1.43864465,4.8553195), (5.26664162,2.72741795), (2.82997942,3.69945884)], [(4.45372057,2.69162941), (1.65100336,4.80288601), (2.64701581,-1.80042851), (5.13276625,2.2803936), (4.78783703,1.86462414), (2.06573081,0.426943481), (2.03197026,4.65510082), (5.26664162,2.72741795), (2.82997942,3.69945884)]]> : tensor<8x9xcomplex<f32>>
    return %cst : tensor<8x9xcomplex<f32>>
  }
  func.func private @cummax(%arg0: tensor<8x9xcomplex<f32>>) -> tensor<8x9xcomplex<f32>> {
    %cst = stablehlo.constant dense<(0xFF800000,0.000000e+00)> : tensor<complex<f32>>
    %0 = stablehlo.broadcast_in_dim %cst, dims = [] : (tensor<complex<f32>>) -> tensor<complex<f32>>
    %1 = "stablehlo.reduce_window"(%arg0, %0) <{padding = dense<[[7, 0], [0, 0]]> : tensor<2x2xi64>, window_dimensions = array<i64: 8, 1>}> ({
    ^bb0(%arg1: tensor<complex<f32>>, %arg2: tensor<complex<f32>>):
      %2 = stablehlo.real %arg1 : (tensor<complex<f32>>) -> tensor<f32>
      %3 = stablehlo.real %arg2 : (tensor<complex<f32>>) -> tensor<f32>
      %4 = stablehlo.compare  EQ, %2, %3,  FLOAT : (tensor<f32>, tensor<f32>) -> tensor<i1>
      %5 = stablehlo.compare  GT, %2, %3,  FLOAT : (tensor<f32>, tensor<f32>) -> tensor<i1>
      %6 = stablehlo.imag %arg1 : (tensor<complex<f32>>) -> tensor<f32>
      %7 = stablehlo.imag %arg2 : (tensor<complex<f32>>) -> tensor<f32>
      %8 = stablehlo.compare  GT, %6, %7,  FLOAT : (tensor<f32>, tensor<f32>) -> tensor<i1>
      %9 = stablehlo.select %4, %8, %5 : tensor<i1>, tensor<i1>
      %10 = stablehlo.select %9, %arg1, %arg2 : tensor<i1>, tensor<complex<f32>>
      stablehlo.return %10 : tensor<complex<f32>>
    }) : (tensor<8x9xcomplex<f32>>, tensor<complex<f32>>) -> tensor<8x9xcomplex<f32>>
    return %1 : tensor<8x9xcomplex<f32>>
  }
}