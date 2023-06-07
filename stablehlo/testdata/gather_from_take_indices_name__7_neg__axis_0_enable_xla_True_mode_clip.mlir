// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<10x10x10xf32>, tensor<5xi32>)
    %1 = call @expected() : () -> tensor<5x10x10xf32>
    %2 = call @_take(%0#0, %0#1) : (tensor<10x10x10xf32>, tensor<5xi32>) -> tensor<5x10x10xf32>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<5x10x10xf32>, tensor<5x10x10xf32>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<10x10x10xf32>, tensor<5xi32>) {
    %0 = stablehlo.constant dense<"0x000000000000803F0000004000004040000080400000A0400000C0400000E0400000004100001041000020410000304100004041000050410000604100007041000080410000884100009041000098410000A0410000A8410000B0410000B8410000C0410000C8410000D0410000D8410000E0410000E8410000F0410000F84100000042000004420000084200000C4200001042000014420000184200001C4200002042000024420000284200002C4200003042000034420000384200003C4200004042000044420000484200004C4200005042000054420000584200005C4200006042000064420000684200006C4200007042000074420000784200007C42000080420000824200008442000086420000884200008A4200008C4200008E42000090420000924200009442000096420000984200009A4200009C4200009E420000A0420000A2420000A4420000A6420000A8420000AA420000AC420000AE420000B0420000B2420000B4420000B6420000B8420000BA420000BC420000BE420000C0420000C2420000C4420000C6420000C8420000CA420000CC420000CE420000D0420000D2420000D4420000D6420000D8420000DA420000DC420000DE420000E0420000E2420000E4420000E6420000E8420000EA420000EC420000EE420000F0420000F2420000F4420000F6420000F8420000FA420000FC420000FE420000004300000143000002430000034300000443000005430000064300000743000008430000094300000A4300000B4300000C4300000D4300000E4300000F430000104300001143000012430000134300001443000015430000164300001743000018430000194300001A4300001B4300001C4300001D4300001E4300001F430000204300002143000022430000234300002443000025430000264300002743000028430000294300002A4300002B4300002C4300002D4300002E4300002F430000304300003143000032430000334300003443000035430000364300003743000038430000394300003A4300003B4300003C4300003D4300003E4300003F430000404300004143000042430000434300004443000045430000464300004743000048430000494300004A4300004B4300004C4300004D4300004E4300004F430000504300005143000052430000534300005443000055430000564300005743000058430000594300005A4300005B4300005C4300005D4300005E4300005F430000604300006143000062430000634300006443000065430000664300006743000068430000694300006A4300006B4300006C4300006D4300006E4300006F430000704300007143000072430000734300007443000075430000764300007743000078430000794300007A4300007B4300007C4300007D4300007E4300007F43000080430080804300008143008081430000824300808243000083430080834300008443008084430000854300808543000086430080864300008743008087430000884300808843000089430080894300008A4300808A4300008B4300808B4300008C4300808C4300008D4300808D4300008E4300808E4300008F4300808F43000090430080904300009143008091430000924300809243000093430080934300009443008094430000954300809543000096430080964300009743008097430000984300809843000099430080994300009A4300809A4300009B4300809B4300009C4300809C4300009D4300809D4300009E4300809E4300009F4300809F430000A0430080A0430000A1430080A1430000A2430080A2430000A3430080A3430000A4430080A4430000A5430080A5430000A6430080A6430000A7430080A7430000A8430080A8430000A9430080A9430000AA430080AA430000AB430080AB430000AC430080AC430000AD430080AD430000AE430080AE430000AF430080AF430000B0430080B0430000B1430080B1430000B2430080B2430000B3430080B3430000B4430080B4430000B5430080B5430000B6430080B6430000B7430080B7430000B8430080B8430000B9430080B9430000BA430080BA430000BB430080BB430000BC430080BC430000BD430080BD430000BE430080BE430000BF430080BF430000C0430080C0430000C1430080C1430000C2430080C2430000C3430080C3430000C4430080C4430000C5430080C5430000C6430080C6430000C7430080C7430000C8430080C8430000C9430080C9430000CA430080CA430000CB430080CB430000CC430080CC430000CD430080CD430000CE430080CE430000CF430080CF430000D0430080D0430000D1430080D1430000D2430080D2430000D3430080D3430000D4430080D4430000D5430080D5430000D6430080D6430000D7430080D7430000D8430080D8430000D9430080D9430000DA430080DA430000DB430080DB430000DC430080DC430000DD430080DD430000DE430080DE430000DF430080DF430000E0430080E0430000E1430080E1430000E2430080E2430000E3430080E3430000E4430080E4430000E5430080E5430000E6430080E6430000E7430080E7430000E8430080E8430000E9430080E9430000EA430080EA430000EB430080EB430000EC430080EC430000ED430080ED430000EE430080EE430000EF430080EF430000F0430080F0430000F1430080F1430000F2430080F2430000F3430080F3430000F4430080F4430000F5430080F5430000F6430080F6430000F7430080F7430000F8430080F8430000F9430080F9430000FA430080FA430000FB430080FB430000FC430080FC430000FD430080FD430000FE430080FE430000FF430080FF4300000044004000440080004400C0004400000144004001440080014400C0014400000244004002440080024400C0024400000344004003440080034400C0034400000444004004440080044400C0044400000544004005440080054400C0054400000644004006440080064400C0064400000744004007440080074400C0074400000844004008440080084400C0084400000944004009440080094400C0094400000A4400400A4400800A4400C00A4400000B4400400B4400800B4400C00B4400000C4400400C4400800C4400C00C4400000D4400400D4400800D4400C00D4400000E4400400E4400800E4400C00E4400000F4400400F4400800F4400C00F4400001044004010440080104400C0104400001144004011440080114400C0114400001244004012440080124400C0124400001344004013440080134400C0134400001444004014440080144400C0144400001544004015440080154400C0154400001644004016440080164400C0164400001744004017440080174400C0174400001844004018440080184400C0184400001944004019440080194400C0194400001A4400401A4400801A4400C01A4400001B4400401B4400801B4400C01B4400001C4400401C4400801C4400C01C4400001D4400401D4400801D4400C01D4400001E4400401E4400801E4400C01E4400001F4400401F4400801F4400C01F4400002044004020440080204400C0204400002144004021440080214400C0214400002244004022440080224400C0224400002344004023440080234400C0234400002444004024440080244400C0244400002544004025440080254400C0254400002644004026440080264400C0264400002744004027440080274400C0274400002844004028440080284400C0284400002944004029440080294400C0294400002A4400402A4400802A4400C02A4400002B4400402B4400802B4400C02B4400002C4400402C4400802C4400C02C4400002D4400402D4400802D4400C02D4400002E4400402E4400802E4400C02E4400002F4400402F4400802F4400C02F4400003044004030440080304400C0304400003144004031440080314400C0314400003244004032440080324400C0324400003344004033440080334400C0334400003444004034440080344400C0344400003544004035440080354400C0354400003644004036440080364400C0364400003744004037440080374400C0374400003844004038440080384400C0384400003944004039440080394400C0394400003A4400403A4400803A4400C03A4400003B4400403B4400803B4400C03B4400003C4400403C4400803C4400C03C4400003D4400403D4400803D4400C03D4400003E4400403E4400803E4400C03E4400003F4400403F4400803F4400C03F4400004044004040440080404400C0404400004144004041440080414400C0414400004244004042440080424400C0424400004344004043440080434400C0434400004444004044440080444400C0444400004544004045440080454400C0454400004644004046440080464400C0464400004744004047440080474400C0474400004844004048440080484400C0484400004944004049440080494400C0494400004A4400404A4400804A4400C04A4400004B4400404B4400804B4400C04B4400004C4400404C4400804C4400C04C4400004D4400404D4400804D4400C04D4400004E4400404E4400804E4400C04E4400004F4400404F4400804F4400C04F4400005044004050440080504400C0504400005144004051440080514400C0514400005244004052440080524400C0524400005344004053440080534400C0534400005444004054440080544400C0544400005544004055440080554400C0554400005644004056440080564400C0564400005744004057440080574400C0574400005844004058440080584400C0584400005944004059440080594400C0594400005A4400405A4400805A4400C05A4400005B4400405B4400805B4400C05B4400005C4400405C4400805C4400C05C4400005D4400405D4400805D4400C05D4400005E4400405E4400805E4400C05E4400005F4400405F4400805F4400C05F4400006044004060440080604400C0604400006144004061440080614400C0614400006244004062440080624400C0624400006344004063440080634400C0634400006444004064440080644400C0644400006544004065440080654400C0654400006644004066440080664400C0664400006744004067440080674400C0674400006844004068440080684400C0684400006944004069440080694400C0694400006A4400406A4400806A4400C06A4400006B4400406B4400806B4400C06B4400006C4400406C4400806C4400C06C4400006D4400406D4400806D4400C06D4400006E4400406E4400806E4400C06E4400006F4400406F4400806F4400C06F4400007044004070440080704400C0704400007144004071440080714400C0714400007244004072440080724400C0724400007344004073440080734400C0734400007444004074440080744400C0744400007544004075440080754400C0754400007644004076440080764400C0764400007744004077440080774400C0774400007844004078440080784400C0784400007944004079440080794400C07944"> : tensor<10x10x10xf32>
    %1 = stablehlo.constant dense<[0, 1, 2, 3, -10]> : tensor<5xi32>
    return %0, %1 : tensor<10x10x10xf32>, tensor<5xi32>
  }
  func.func private @expected() -> tensor<5x10x10xf32> {
    %0 = stablehlo.constant dense<"0x000000000000803F0000004000004040000080400000A0400000C0400000E0400000004100001041000020410000304100004041000050410000604100007041000080410000884100009041000098410000A0410000A8410000B0410000B8410000C0410000C8410000D0410000D8410000E0410000E8410000F0410000F84100000042000004420000084200000C4200001042000014420000184200001C4200002042000024420000284200002C4200003042000034420000384200003C4200004042000044420000484200004C4200005042000054420000584200005C4200006042000064420000684200006C4200007042000074420000784200007C42000080420000824200008442000086420000884200008A4200008C4200008E42000090420000924200009442000096420000984200009A4200009C4200009E420000A0420000A2420000A4420000A6420000A8420000AA420000AC420000AE420000B0420000B2420000B4420000B6420000B8420000BA420000BC420000BE420000C0420000C2420000C4420000C6420000C8420000CA420000CC420000CE420000D0420000D2420000D4420000D6420000D8420000DA420000DC420000DE420000E0420000E2420000E4420000E6420000E8420000EA420000EC420000EE420000F0420000F2420000F4420000F6420000F8420000FA420000FC420000FE420000004300000143000002430000034300000443000005430000064300000743000008430000094300000A4300000B4300000C4300000D4300000E4300000F430000104300001143000012430000134300001443000015430000164300001743000018430000194300001A4300001B4300001C4300001D4300001E4300001F430000204300002143000022430000234300002443000025430000264300002743000028430000294300002A4300002B4300002C4300002D4300002E4300002F430000304300003143000032430000334300003443000035430000364300003743000038430000394300003A4300003B4300003C4300003D4300003E4300003F430000404300004143000042430000434300004443000045430000464300004743000048430000494300004A4300004B4300004C4300004D4300004E4300004F430000504300005143000052430000534300005443000055430000564300005743000058430000594300005A4300005B4300005C4300005D4300005E4300005F430000604300006143000062430000634300006443000065430000664300006743000068430000694300006A4300006B4300006C4300006D4300006E4300006F430000704300007143000072430000734300007443000075430000764300007743000078430000794300007A4300007B4300007C4300007D4300007E4300007F43000080430080804300008143008081430000824300808243000083430080834300008443008084430000854300808543000086430080864300008743008087430000884300808843000089430080894300008A4300808A4300008B4300808B4300008C4300808C4300008D4300808D4300008E4300808E4300008F4300808F43000090430080904300009143008091430000924300809243000093430080934300009443008094430000954300809543000096430080964300009743008097430000984300809843000099430080994300009A4300809A4300009B4300809B4300009C4300809C4300009D4300809D4300009E4300809E4300009F4300809F430000A0430080A0430000A1430080A1430000A2430080A2430000A3430080A3430000A4430080A4430000A5430080A5430000A6430080A6430000A7430080A7430000A8430080A8430000A9430080A9430000AA430080AA430000AB430080AB430000AC430080AC430000AD430080AD430000AE430080AE430000AF430080AF430000B0430080B0430000B1430080B1430000B2430080B2430000B3430080B3430000B4430080B4430000B5430080B5430000B6430080B6430000B7430080B7430000B8430080B8430000B9430080B9430000BA430080BA430000BB430080BB430000BC430080BC430000BD430080BD430000BE430080BE430000BF430080BF430000C0430080C0430000C1430080C1430000C2430080C2430000C3430080C3430000C4430080C4430000C5430080C5430000C6430080C6430000C7430080C743000000000000803F0000004000004040000080400000A0400000C0400000E0400000004100001041000020410000304100004041000050410000604100007041000080410000884100009041000098410000A0410000A8410000B0410000B8410000C0410000C8410000D0410000D8410000E0410000E8410000F0410000F84100000042000004420000084200000C4200001042000014420000184200001C4200002042000024420000284200002C4200003042000034420000384200003C4200004042000044420000484200004C4200005042000054420000584200005C4200006042000064420000684200006C4200007042000074420000784200007C42000080420000824200008442000086420000884200008A4200008C4200008E42000090420000924200009442000096420000984200009A4200009C4200009E420000A0420000A2420000A4420000A6420000A8420000AA420000AC420000AE420000B0420000B2420000B4420000B6420000B8420000BA420000BC420000BE420000C0420000C2420000C4420000C642"> : tensor<5x10x10xf32>
    return %0 : tensor<5x10x10xf32>
  }
  func.func private @_take(%arg0: tensor<10x10x10xf32>, %arg1: tensor<5xi32>) -> tensor<5x10x10xf32> {
    %0 = stablehlo.broadcast_in_dim %arg1, dims = [0] : (tensor<5xi32>) -> tensor<5x1xi32>
    %1 = "stablehlo.gather"(%arg0, %0) {dimension_numbers = #stablehlo.gather<offset_dims = [1, 2], collapsed_slice_dims = [0], start_index_map = [0], index_vector_dim = 1>, slice_sizes = dense<[1, 10, 10]> : tensor<3xi64>} : (tensor<10x10x10xf32>, tensor<5x1xi32>) -> tensor<5x10x10xf32>
    return %1 : tensor<5x10x10xf32>
  }
}

