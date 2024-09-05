// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<5x6x7xf32> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<[[[0], [1]], [[2], [3]]]> : tensor<2x2x1xi64>
    %0:2 = call @inputs() : () -> (tensor<5x6x7xf32>, tensor<5x2x2x7xf32>)
    %1 = call @expected() : () -> tensor<5x6x7xf32>
    %2 = "stablehlo.scatter"(%0#0, %c, %0#1) <{scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 3], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1], index_vector_dim = 2>, unique_indices = true}> ({
    ^bb0(%arg0: tensor<f32>, %arg1: tensor<f32>):
      %3 = stablehlo.minimum %arg0, %arg1 : tensor<f32>
      stablehlo.return %3 : tensor<f32>
    }) : (tensor<5x6x7xf32>, tensor<2x2x1xi64>, tensor<5x2x2x7xf32>) -> tensor<5x6x7xf32>
    stablehlo.custom_call @check.expect_close(%2, %1) {has_side_effect = true} : (tensor<5x6x7xf32>, tensor<5x6x7xf32>) -> ()
    return %2 : tensor<5x6x7xf32>
  }
  func.func private @inputs() -> (tensor<5x6x7xf32> {mhlo.layout_mode = "default"}, tensor<5x2x2x7xf32> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0xDEA6A53D72F318BFFE9D624018D5DB3F7F73E4BDE3E895C0AC211EC027D5C0BF28793EBEC4853640F4A187C0A54CE7C0C2E64BBF9DEEB6BF7B7854BFD62923C09CA7083F2DBEBABFCA7C7D40B51C6BC08B339A40B55F47C00EACA540113E01C0A28D073E12258B40441566C0CFAE8EBFA158363F5CD31041283CCA3F578F36C0F146B93F755FC2BE1CC1E03D017FEFBF77DF243F41535EC0A2F6824011DB06401418A2C0D61D90BFC41652C0A8D846BEF96354C0B8D6FF3FEC1E3F3F41F007C08A2B70C0121F19C009A0273F454967C0A2112940681B3B3F8CAF2C3FF84096C0CFAF1FBFF6FCAAC0E01939C042B44EBE58CD17C041F4933FAE15ED3DD03F88BF876328C03ED543C05C3DAABE290005416A66D8C04C5254C0D2CAC2BF7DC4373FE91702BE1D390FBF1D3C5340ECB8C14050F01D3FAA4E7EBF4BF0B6BF729E164098E8DCBFBB960D3ECC6758C0C557B43F95C34AC0437AC83F68C5CC3FC4F237BF280401C0743FE33F15075540C76F06C0D8FDFCBF408F01BE04119A4036A4EEBF51AD1CC0483EEABD8D6F0B40A2FBCF407B6E5FC01938D2BF48B28540A65AC0BF3A5EA6BFD74C8F407BA50740469F61BF9BE9BFBFD7EEA84085AAF64071B0E24056AEF33F32D9703F3325E7BFA5A95740DB8491BF4F0372C0402190C0C2EBBDBC74C2BC3FCDB130BF46F2A7BF958B66405BDFF93F668DC540F78D09C0200714C036199E3E4885BB3F4FBDF33F1BA385BFEC518DBFB2000F40E7244EBE36CEC2BE709D70BF3A15E3407D61FBC0476E794000C65040C807FFBFFEF2893E752D82405163B33F480593404128933FB2388440EB342940EA40813EF02D05C073252240A42BBA3C3A5F51C019EF15407B645240632A1EBF4858A8400D9002404D3FC34075D04B4002DD7F3FA0081B4015D11E40A90BF9BF310AF83FE8BE65BFA301854048C290C0F8353F3EC1A302405D3F1CBE449F803F4BA11EC015C0924072F6AC402B41A8BF5AB3FD3D5C411D3F66E3E1BFB74B0140C0BD2B402D76963FB65CB4BEB5179C4058D881BF9EF286C0A9AFB23FF80AACBEB05220BFF05C054082E6C340CC809640B531CCC00CFFE93FFFF9AF3F792FC93E5E3FA9402C5823BDF6E080BF79611E4042E1E3BC1D18F63FA62B99406AA1514086759A3F683EE0BF9F52BDC068466B3F10062DC0"> : tensor<5x6x7xf32>
    %cst_0 = stablehlo.constant dense<"0x4120FFC07D0728C0AD1D713FAAC26340D21A203F8B820740B5F0C33FBE8FF5BDCDF8BA4032F5F9BF05A507405C0E5940BF9421BFC1AAE8BF288D2A402B6144407C2448BFBFB4D9BF7B67F93F3535AD4005067BC0ED4BFE3E4904A23F58CB273EB13E853F91CD09C079CBF73F97B926408280A43E39E4C5BF95FF0DBF778FB9BF5682F5BB178DA5BE8B17A2C095260AC0B3A26E40F5192740181D203DE40F593FB985ABC0103617C085EE04BF30976DBE51A983C024E616406074A13F6174B3C05F69603DEA32EFC09A706E40481611C05B1D8DBF2B79B4C079440C41BAEA07BEBE86FB3F3B7829C084401CBEBF803BC0914D0F40BA1497BF60382C404D1D4D4003ED15BF381C6DBFF870083EE7E9353F58CFFDBF57E181C08393433C7C71E33DF238693EDC9308C02097703F3B564F40C7573A3FC9AF7C4010536CC0DEC1A9401F9F16C097CD3B40E148C7BF53E023C0E1C7953F6F1DEEBF72F693405AC8A1BE2206B5C00BBE16BFC401EF3F0DA201C042FAC73F22370AC088B022BF0559E7407EF4CB40929265C0E9511A40E71658C02F5E9CC0EEEC3BBF11FCAC4004E1A2BF61FFECBF553988BF2678A1406A59EBBF37D424BEC0920040B5E758C0BF650BC00474A0BF1F4A65C08DD3113FC3CA4EBF23D639408AA7AEC03CFA213FC81BE23FF31EF63F8A211B40E1DDE33E2036024009D28DC0AA7EFDBEE2FD12C02B9BA9C003B24F3D63CD443FCA92CDBDDC8FC83F5F08A03EA516ABC00B109FC034684540481799C0E14D50BFAE34A5BFBC4AD53F"> : tensor<5x2x2x7xf32>
    return %cst, %cst_0 : tensor<5x6x7xf32>, tensor<5x2x2x7xf32>
  }
  func.func private @expected() -> (tensor<5x6x7xf32> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0x4120FFC07D0728C0AD1D713F18D5DB3F7F73E4BDE3E895C0AC211EC027D5C0BF28793EBE32F5F9BFF4A187C0A54CE7C0C2E64BBFC1AAE8BF7B7854BFD62923C07C2448BFBFB4D9BF7B67F93FB51C6BC005067BC0B55F47C04904A23F113E01C0A28D073E91CD09C0441566C0CFAE8EBFA158363F5CD31041283CCA3F578F36C0F146B93F755FC2BE1CC1E03D017FEFBF77DF243F41535EC0A2F6824011DB06401418A2C0D61D90BFC41652C039E4C5BFF96354C0778FB9BF5682F5BB41F007C08B17A2C0121F19C009A0273F454967C0181D203D681B3B3FB985ABC0F84096C0CFAF1FBFF6FCAAC051A983C042B44EBE58CD17C06174B3C05F69603DEA32EFC0876328C03ED543C05B1D8DBF2B79B4C06A66D8C04C5254C0D2CAC2BF7DC4373FE91702BE1D390FBF1D3C5340ECB8C14050F01D3FAA4E7EBF4BF0B6BF729E164098E8DCBFBB960D3ECC6758C0C557B43F95C34AC03B7829C084401CBEBF803BC0280401C0BA1497BF60382C40C76F06C0D8FDFCBF381C6DBFF870083E36A4EEBF51AD1CC057E181C08393433C7C71E33D7B6E5FC0DC9308C02097703FA65AC0BF3A5EA6BFC9AF7C4010536CC0469F61BF1F9F16C097CD3B40E148C7BF53E023C056AEF33F32D9703F3325E7BFA5A95740DB8491BF4F0372C0402190C0C2EBBDBC74C2BC3FCDB130BF46F2A7BF958B66405BDFF93F668DC540F78D09C0200714C036199E3E5AC8A1BE2206B5C01BA385BFEC518DBF0DA201C0E7244EBE22370AC0709D70BF3A15E3407D61FBC0929265C0E9511A40E71658C02F5E9CC0EEEC3BBF5163B33F04E1A2BF61FFECBF553988BFEB3429406A59EBBFF02D05C0C0920040B5E758C03A5F51C019EF15407B645240632A1EBF4858A8400D9002404D3FC34075D04B4002DD7F3FA0081B4015D11E40A90BF9BF310AF83FE8BE65BFA301854048C290C01F4A65C08DD3113FC3CA4EBF449F803F8AA7AEC03CFA213FC81BE23F2B41A8BF5AB3FD3DE1DDE33E66E3E1BF09D28DC0AA7EFDBEE2FD12C02B9BA9C003B24F3D58D881BF9EF286C0A9AFB23FF80AACBEA516ABC00B109FC034684540481799C0B531CCC0AE34A5BFFFF9AF3F792FC93E5E3FA9402C5823BDF6E080BF79611E4042E1E3BC1D18F63FA62B99406AA1514086759A3F683EE0BF9F52BDC068466B3F10062DC0"> : tensor<5x6x7xf32>
    return %cst : tensor<5x6x7xf32>
  }
}