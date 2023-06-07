// RUN-DISABLED(#1278): stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x20xf16>
    %1 = call @expected() : () -> tensor<20x20xf16>
    %2 = stablehlo.log_plus_one %0 : tensor<20x20xf16>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xf16>, tensor<20x20xf16>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x20xf16> {
    %0 = stablehlo.constant dense<"0x60C04945BFC1DD3E9B3E43B31A452FBA7B1B0CBDAB3F8839D24450BB102E19C4D344BAC3E6C159398441BEBA38B8D33E47BCCABC7FC06FC15A44EF4006C0F441F4231937E644093D07C4DFC3213D51B95941B5B9FAB2AB4568C30A2C5735CC3ECC38BD3416C3A5C071BC213F1F42FBB2DF2EF6409644F1C2544048453140CE3CE6C4BAC20ABF1C4636BE13456133EEB2DE3FA642CC402640E4C2D73917B215B68D40F53805C8B8402541C1BF113F704157B91B4330B876BDDE3B36BFCF416B42354686C56DC6E9BA00C321BCA6C00337603AB0C0B4AA3936363D5EB94B3C55C4BA38A833193D6341D94025BF1BC2F7BB6BB0A83BADBC96BAF441B840BABEAABF8945F0B8CF37074051C40E43A841644038B8A844883E61B08839F5C11B3FFA32B4B1BF43323F703C24BCCF422941B33DDCC4944188BF704277BE0FB4C1B86E3D8337C9C37E399843494084C342BA5ABAF6C318C1F0C113457B3CCAC147C008BE0242B738B0BED7BEE1C0E53FF8BD58C60643643CCEBD06BDB3C419449F447140A3C4403FA5BE3AC0A838C0C13CBA1AC5A43DECC3E8C144449C3B3F4472C39EBE10C43B3F2B39E2C2AC402EB8CE378EBCD4C3E54008C56A2F6B3C12437CBE3C3A57475447963E2141DF3E70C28741C4461BC3C5C6F642844110C2A644633ECE3A47439639B0B8F54529435DB58F41413D63C09D438BBC4DBFFD2F83AEA6BDBA40EB3C1044E23AF740CB3EE83FDE405A3BC641DA3F6DC4D045A53DC6C12CBEBD415FBB38BB514625C01B3C804385C45F413FC154424040BE40863E25C0B13D0F3E2BBCA938FF44993C853FA93E95C4533C5E39B937AABCC3B9CE417540C1C1C7C4FBB81CC56640E2C271C1ADBF7BC13EC1EB4339442CC4F338D3459D40DDC293B899364FB56C39473E1833D634B8C39E45533AB9BCCA3AEDC505BF60459AC41A3F51BE3BBDE741C7C55244A3BB0BC10343B43F263D5F3B6FB4CB44294417397541BE3B1A3C0E401CC6AE433EC161452CB8E0C26CC16244CDB7A23CABBF2444AB3D12403BC2EC3A38BF0C3B22C4EEC4824751BAFFC0C9C479BE1B3EF543363CBBC1B4BE353FE2B230452E401FC6914587BDC2C03B387DBD554336B27444A2C1E8B6"> : tensor<20x20xf16>
    return %0 : tensor<20x20xf16>
  }
  func.func private @expected() -> tensor<20x20xf16> {
    %0 = stablehlo.constant dense<"0x00FE5A3F00FEFD3BCE3B1EB43C3FEEBD781B00FE493C34380C3FE9C0CB2D00FE0C3F00FE00FE18384C3D66BFFFB9F83B00FE00FE00FE00FEB63EF93C00FE863DE423DF35193F843A00FE00FE993A5EBC343D00BDDFB3973F00FED52B9C34F23B8437263400FE00FE00FE173C9B3DE0B3872EFD3CE23E00FE9C3C5A3F853C503A00FE00FE00FED83F00FE373FA432CFB35A3CDB3DE53C7E3C00FE6338C1B2A7B7BF3CB63700FED93C183D00FE123C413D67BC113EEEB900FE7A3900FE733DC03DE63F00FE00FEF9BF00FE00FE00FED135B03800FEE3AA4235AC3A72BCD63900FE6E37DD32923A3A3DEC3C00FE00FE6DC5C1B05F3900FEEFBE863DD93C00FE00FE823FAFBB5D366A3C00FE0A3E5F3DA63CFFB9EE3EBF3BB6B0343800FE163C503248B2563E1E3CF93900FEEF3D1A3D173B00FE543D00FEC23D00FEAEB437BBDC3A293600FE2E38463E953C00FE19BE52BE00FE00FE00FE373F043A00FE00FE00FE8D3D6B3700FE00FE00FE5C3C00FE00FE073EED3900FE00FE00FE843EE83EAE3C00FE233C00FE00FE573700FE0BBE00FE0A3B00FE00FEA53E5939A13E00FE00FE00FE213CFA3700FED23CEAB95D3600FE00FEF33C00FE042FF5390C3E00FE9C383E403D40C93B163D003C00FE4D3D194000FE00FE003E4C3D00FEED3EA33BED38243E3D380EBBC23F163E88B6513DB53A00FE473E00FE00FE872FDEAE00FEDA3C6B3A7D3EF738FE3CF23B5D3CEF3C37396E3D583C00FEAD3F0A3B00FE00FE6A3D16C1A7C0F63F00FEA7393C3E00FE383D00FEB53D8F3CDC3CBD3B00FE143B613B00FE57372A3F1E3A3B3CD73B00FEDE391B384D3600FE18BD723DB03C00FE00FECBBB00FEA73C00FE00FE00FE00FE00FE683E9D3E00FEB637AF3FC93C00FEC9BA863574B624388D3B68323A3400FE8F3FAA3800FEEA3800FE00FE693F00FE153C00FE00FE7F3D00FEB03E2FC200FE063E4B3C9E3A3A3931B5073F903EE237443D6A39A5396E3C00FE4F3E00FE693FE6B900FE00FEBC3E58B9273A00FE8C3E103B713C00FEFD3800FE0E3900FE00FE48403CBE00FE00FE00FE6B3B6B3EC13900FE00FE1F3CC0B34A3F833C00FE873F00FE00FECC3600FE293EE8B2C93E00FE85B8"> : tensor<20x20xf16>
    return %0 : tensor<20x20xf16>
  }
}
