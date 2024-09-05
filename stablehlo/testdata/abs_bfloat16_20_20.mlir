// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<20x20xbf16> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %0 = call @inputs() : () -> tensor<20x20xbf16>
    %1 = call @expected() : () -> tensor<20x20xbf16>
    %2 = stablehlo.abs %0 : tensor<20x20xbf16>
    stablehlo.custom_call @check.expect_close(%2, %1) {has_side_effect = true} : (tensor<20x20xbf16>, tensor<20x20xbf16>) -> ()
    return %2 : tensor<20x20xbf16>
  }
  func.func private @inputs() -> (tensor<20x20xbf16> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0x29C0C7404A4071C01DBF1FC082C0D5C0C93FCCBF754026406DC055409040B63FACBFD5BF4DBF1540613FF6BE5B4057BF7CBF7C3FE4C01FBB4B405F40293F9EBEADBEC2BF153DE23F7240CE40C24027402940ED3D95BF913E84C0FA3F2A3FA44034BFCEBF46C0EA3FC8BF28C0BDC04CBF2A409A3F1C4021C028BF92C05B40AE3F58C036C055C0AAC051BDC1BF863E774073C0203FD73FC7C01D4015C0834009C1AC40B13FD13F8B3F9EBF1B3F07C067C037404EC0B44092BF54C0E640FD3E6CBF7B3F84BF9DBF8F4051C00A408B40BDBEC7C08A407AC0A3C0F73C553FD03F45402C40C940843FBA3F58BF51BF2B40AD3F293F74401C4085C027C0A73E81C05A3F9BC0E1BF2E40C7401AC0D240923E63BF71BEF4BE89C0F93D8A3F7E40D13FAFC014C0DCBFA5BF1440B7BF0140AFBF26405EBF064150C0803F9B3FA5400DC0B64012BF7AC09640044003C05BBF57BE83BF4EBFF93F8A3DAD400DBE1F3F52C0FC3FEBBF80BE4240963FBC3DDBC053C03ABF9E3FA1C04F3E98BF15C0AF3F4F3F5CC00A40F2BEC740383FAC3F68C0EABD54407DBF8F406CBF9D3E85BE0CC08EBF2FC0FABE9FC01140F03FA5BF51C00240723F8B3F22C081C04B40B3409D3F884006BF3BC0C03F6EC08CC02A407DBF4FBF59BF1EBF973FD3C09C3F7F3F96BFEA3FE9C05AC0A5BFA7C0F23F5640E23F5E40F640CE405BC0CBC058C085C01A40A43F82405CC0F53F24C085BFAE40863D563F8E3F50C08A3E34C0BF3FA0BD98BF72BE973EA2BFDA4097BE90BF82C05640F3BF71C0BAC0843F1D40FF3F1CC0E73F8C4049C091C04D40843F9BC0F13E37C09A3F234001C0B0BFE23E334081C0E73F36BEB63FBEC0A84051408A3E00C057C00F3F25BE0AC1423F61C0024069C06540C3C04D40A73DAAC0A2BF09BF9DC0F9BFC3BFA44061C08EBDD7C0963E3740193E8E3F83BE9AC0BF3F9C40973FC73FB7BF353FFDBF30BE9CBE12C0A63F493F443F4A40CFBFF1C05CC007C0D23F663F1AC018C02840DBC0B1BF92BE7E3E0BC0ADBF0341143E6FC008C0633F13C095404F3FED3FD0C03DBF45BF35C0A6C0C7C058BEABBF04C0093F15C07EBE97BF303F933F56C0C73F593E4B403BBF6C3FD1BD203F4EBF25BE"> : tensor<20x20xbf16>
    return %cst : tensor<20x20xbf16>
  }
  func.func private @expected() -> (tensor<20x20xbf16> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0x2940C7404A4071401D3F1F408240D540C93FCC3F754026406D4055409040B63FAC3FD53F4D3F1540613FF63E5B40573F7C3F7C3FE4401F3B4B405F40293F9E3EAD3EC23F153DE23F7240CE40C24027402940ED3D953F913E8440FA3F2A3FA440343FCE3F4640EA3FC83F2840BD404C3F2A409A3F1C402140283F92405B40AE3F584036405540AA40513DC13F863E77407340203FD73FC7401D40154083400941AC40B13FD13F8B3F9E3F1B3F0740674037404E40B440923F5440E640FD3E6C3F7B3F843F9D3F8F4051400A408B40BD3EC7408A407A40A340F73C553FD03F45402C40C940843FBA3F583F513F2B40AD3F293F74401C4085402740A73E81405A3F9B40E13F2E40C7401A40D240923E633F713EF43E8940F93D8A3F7E40D13FAF401440DC3FA53F1440B73F0140AF3F26405E3F06415040803F9B3FA5400D40B640123F7A409640044003405B3F573E833F4E3FF93F8A3DAD400D3E1F3F5240FC3FEB3F803E4240963FBC3DDB4053403A3F9E3FA1404F3E983F1540AF3F4F3F5C400A40F23EC740383FAC3F6840EA3D54407D3F8F406C3F9D3E853E0C408E3F2F40FA3E9F401140F03FA53F51400240723F8B3F224081404B40B3409D3F8840063F3B40C03F6E408C402A407D3F4F3F593F1E3F973FD3409C3F7F3F963FEA3FE9405A40A53FA740F23F5640E23F5E40F640CE405B40CB40584085401A40A43F82405C40F53F2440853FAE40863D563F8E3F50408A3E3440BF3FA03D983F723E973EA23FDA40973E903F82405640F33F7140BA40843F1D40FF3F1C40E73F8C40494091404D40843F9B40F13E37409A3F23400140B03FE23E33408140E73F363EB63FBE40A84051408A3E004057400F3F253E0A41423F6140024069406540C3404D40A73DAA40A23F093F9D40F93FC33FA44061408E3DD740963E3740193E8E3F833E9A40BF3F9C40973FC73FB73F353FFD3F303E9C3E1240A63F493F443F4A40CF3FF1405C400740D23F663F1A4018402840DB40B13F923E7E3E0B40AD3F0341143E6F400840633F134095404F3FED3FD0403D3F453F3540A640C740583EAB3F0440093F15407E3E973F303F933F5640C73F593E4B403B3F6C3FD13D203F4E3F253E"> : tensor<20x20xbf16>
    return %cst : tensor<20x20xbf16>
  }
}