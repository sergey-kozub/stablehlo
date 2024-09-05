// RUN: stablehlo-opt --chlo-pre-serialization-pipeline -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-opt --chlo-pre-serialization-pipeline %s | stablehlo-translate --serialize --target=current | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt --chlo-pre-serialization-pipeline %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<20x20xf32> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %0 = call @inputs() : () -> tensor<20x20xf32>
    %1 = call @expected() : () -> tensor<20x20xf32>
    %2 = chlo.erfc %0 : tensor<20x20xf32> -> tensor<20x20xf32>
    stablehlo.custom_call @check.expect_almost_eq(%2, %1) {has_side_effect = true} : (tensor<20x20xf32>, tensor<20x20xf32>) -> ()
    return %2 : tensor<20x20xf32>
  }
  func.func private @inputs() -> (tensor<20x20xf32> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0xE1D4293F64482FC0A6D997C059D32E4004FAC6C03581C83DD997AFBF85428540DC28D63F8E060A3E1CACB73F1A3E9D3F025DFCBE1BB4983F29787640E8B044C00546A63E5F75903F8AC2544030AABC3F110DB53F17A7223E9B040040C8487040FF3A773EBCC3053E55A985C034528340755B49BF8A902FC0F1694B4083FDA5C060F3D03F73E1BBC06213BE3F1D008B3E6CCE0E4131A747C08D0ABE3BA68774C09CA54340035D90BF46029C3FB0A5854058B54CC0BCA42ABF8211F03F553495406363C9C0AEA0BDBE938CC83F1503863FB879C54023EC9DC042556E400AA721C0CDA01040C5930940FF92B34016B906C0192CEF3FE89156C02EEC07C0BD7F97C02B520C404B3906BEC4B056C03C742CBF3587A93F824B2FC0A9BBEC3EFBE1D33FC3A501C0984FB8BE27ACFDBDC36C3D4075158DC07DA84E3F5DB6E8BF065314BF0EA340C07EAC18C0ED4E0CC01378DCBF465477BF36E341BF2BC126C01C052FC0424820C07FA706C0842588406C715AC0C6D9DBBFB468474068B9673FF7639D40A09D29BEC6E617BE5BBB1641336B8FBD84D39E40C943E33F352C64C0A7E435BD22C5CCC052DFB13EE92E783FFED065BE1714E0BF88375CC04C0B91BF19AF0B409ACCE43F675D8040C7395CC014DF2BBEB44D8BBE0B92ADC0215A4A4025BC8140AC7D244094303CC0E4120E3DB98C1E3F56C692BEEC030AC003C4273F9364823EBDD4E5BF43BB06C05F4E8D3F9247913F703EC73F06A9103FB9946A3FA3FE513F0F771D3FC8100A416B8291C0F73B5B4022D993BF0EAD81C0BFA26640FE1248C08D3585BF2CE707BE481E613FC54C7940EFCCF03F0DB1343F9E731040C76DD33EAC5987C0D014F440CB206C40557A59C0D9D751BF6B6CD5BFAA2009C03BAD81C0D4FA673FC4354BC0016EECBEEEEA01BF6DD7DFBF07F9A740F2C4993F51AD3840F25928404751F4BFFF5773C033F592C0C32241BF588D65BFDFB23AC0A895AE3FC28500C08D50B3C06B53A6BFB66B05BF96505DBF0A91A63FADAA65BF67DAF5BEC8C3BA403727603E42A52440E986324040713AC0441C353F97AA32C04D51CDBEFCE9043FDA8E293E1A9AB43F26F9C5BFC8D1F73F7C969DBF1C6D5340A4E66EC089848740C93595BF594B91C03F1DECBEA42AFD3F620353BF299051C09D0A26C04854803F0EA65640C81D954010880640F3C7B93EEA3BE0BFAC0B2CC052A70040B7D4F13E24557EC0AEBCAFC035E60741DEFE55BEE4212240F29FA43FEFEA2D40C550B33ECA4853407D75E240C8E9F0BE8FCE3940CF74803F0422D9BF91B7F2BE75B691401A9E03C0532A69BFC645FE3F9E4606409122AFBE861625C03B530D40FA5E5DBE4D773C4059E51A3F1D8BF53F1D2A6A403770D1BF4460C9BEFB31C23F1F3677BF53E7553EF974313FD44642C08854F740E4EA4D3E924732BFE0412ABF7CDD603FF155973F3A963F40F42C87BF92132AC0A6771F4037D72440398D213F51EC0A40582E984076B9D1BF9875BD40B84C74C09D9845C00A5230C0320865406AAA743D8AB8544099F0063F037C3A40597DB43F86F546401457B240826C16BFC9C16CBF7D9ABEC011911F40BF710FC0F56F49C1DDEC15BF441C2DC025144DBF1E7CB440BF8B9640B308B23F4BFFE03F1084014010E2EE3F74AA8D3FDFBBB33F29BB8EC0D1962540990A2DC001FA5E400D00EB3F4F7CD03F60492E3FB31A9840970B5B4082440DC0AC4208C026EAD93F2E32CE3D03A87CBD94CD1A3EEFD1BCC0C44105C09AFF023FD11D5FC041B0883F712690BF5E6EABC0C869FB3FDD6DF0C05DD35ABF4B599B3FEF74C4BED1D97F3F0D037A3DB36423C0933A25BFAA2ACBBF8393B2405D74DE3FA19348BFD5A920C01771D43E9255A540A2860EBF845A3FBF36A78D402B046EC0C77094C082CF1140C14379406AEDD8BF824F64C063B9FFBD59561040BD831BC00B68A4BEDB4801C15F017DC0BAD3A940E91A12C05D6DD7C043E2D13F164A9EBF7F407FC030D25840078121C0EBF258C0380C184009EB1DC06A5F2F3D85D6944063363240237B74BF1193ADBFB5E36B40E73A0BC06EC47640915E5BC0BB51F8BF033FA5BFC8FAA540EA6CAFBFC48BDABFF30B8FBFD78E39C0BADFA93F03A4743D04DC3D40354AEC3F669CA4C0E66F363F4ABCB0C0EB28E8BF07CE06C19717C8BD4F5DA94056D9D3BFEF3A6ABF0B0E1D3FFDBEB93F589446C07B881BC041D87FBF54E37340AA4B643E7E641DC07BC924403D94583FDA91FF3F"> : tensor<20x20xf32>
    return %cst : tensor<20x20xf32>
  }
  func.func private @expected() -> (tensor<20x20xf32> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0xEB3FB23E7BFCFF3F00000040AFC1EA380000004037CF633FD14BF93F88408531603E933C584C593F80C72D3DB79EA83D7AD2C13F408BBB3D56F05C338CFFFF3FE562253F6B41E23D956B2D365608183DD6363A3DE07F523FFC16993B1BF5EB33DE963B3FB07A5A3F000000407FFADE3125F4DD3F92FCFF3F6199E936000000405DC0AB3C00000040E452123D5576333FF5260704AAFFFF3F21537E3FFFFFFF3F75FC803737D4F13F779AAD3D103F7031CDFFFF3F61BBD33F07F1023C5C563C2E00000040FF24B33F5EC8DA3C31080E3EA183402200000040AD54153465F4FF3FC7BBB63ADC031B3B7A4C16279DA0FF3F21D5063CEEFFFF3F8BA8FF3F00000040CF10FD3AF5D2923FEEFFFF3F4762D43F2D1D7A3D7CFCFF3FFE5F033F418D9D3C4877FF3FFAD4B13F81CC913F7870EE370000004094D8813ED8B3FE3FFD30CB3F52FFFF3FB1E7FF3FACC0FF3F3019FE3F2101EA3FA0A1DB3F80F8FF3F65FCFF3FFAF2FF3F24A0FF3F1660F430F4FFFF3FEA0FFE3F0E5E3037CC514D3E40CA762CF4B4973FE944953F0000000011198A3F6F071D2CFD46453CFCFFFF3FE168863F000000409F8A1F3F32742E3EFFE09F3F514CFE3FF6FFFF3F000BF23F19AE043BA5003C3C54187132F6FFFF3F2B04983F2A59A63F000000403661023751FC283242DF9139F3FEFF3F05FC753F861FC33E314CA83FF3B4FF3F9F44B53E63FE373F0794FE3FACA0FF3F82A0F23D4623DE3D0002E33CC431D93EB3B1473E03ED7B3EA3CBC43EDD29C60700000040BC6AAA35CAE5F23F0000004048DFB934AEFFFF3FF8F0ED3F8B0E933FD5C45A3ECD2B1B33DCACFF3B79E9A23E0838B93A48290F3F00000040BF209D13EF784234F3FFFF3F3477E03FF6A5FD3FE6AFFF3F00000040C5CF4C3EC4FFFF3F503EBE3FA476C33F1D49FE3F8781002A32F4B63D8F393C38B8D65039591CFF3FFFFFFF3F000000404E64DB3F72CAE53FCAFEFF3F33215C3D296CFF3F000000409E89F73FFDFAC43F8EA6E33F0A99863DD9D1E53F715FC03FE9BA30255FC3413F67F38F397167A738C2FEFF3F9F56A23E6BFDFF3F66F5B63F67F3EC3E269A503F096B3C3DEC52FC3F7786CA3B0F8CF53F67444836FFFFFF3FF7011131234CF33F00000040E62BBE3FBFF3A83B31CDE03FE1FFFF3F06F8FF3FE3FB1F3E1B3D0D36A457412E696C413BB59B1B3F694EFE3F4BFBFF3FEA80923B2A10013F00000040000000404A977F09F4BF9D3F5E52B2394F2C8D3D24CFFE3810D21E3FDE584B3608B88719DA42BF3FC600293885901F3E4DE5FD3F13ABBF3FB1A9032FF288FF3F0BB1E63F8EABA23B5C03453B298BAF3F57F7FF3F3BBEEA3A80BE9E3F37D90238A3CAC83E318EDA3B00917534BD5AFD3F4B02B63FDBB0023D70FAE93F7486443F1F63A73E6CFFFF3FDA7A821271AF463F8B70D63F9497D33FEE4B5B3EED91C13D68FFC0373AAEEE3F64FAFF3F9610DF39568F8D39518ABE3EA1610C3B4EE8992D6760FD3FE3848124FFFFFF3F96FFFF3FCCFCFF3FACFADF340AC46E3FA2272E364179E93EB8621E3805F93C3D5CA33837CDE86827BA08CC3F7690E73F000000409539DD39FFCDFF3F00000040AED5CB3FB8FBFF3F5E12DF3FB92AD926982CFC2D6172493DD8B9533CA0FA893B301C083C97B6F03D99BD403D0000004027BB8439B1FBFF3FFDFE5F35DC571A3C7C1AAE3C9CD9AB3E92889D2D8109AE350FC5FF3FAAAAFF3FF087833CBA03633FD9E5883F49A9543F000000400996FF3FDE43F03EF9FFFF3F4A22063EEDC2F13F00000040855CB33B00000040DAFAE23F7851B03DD0D0B43F7F52213EDE636E3FFDF5FF3FD2BED13FC2D3FC3FCB3C5627CF08653C45B7DD3F63F3FF3F04AE0E3FADFF992A81D2C83FD9D1DA3FD94FD32FFFFFFF3F0000004025DCA63AC3DB1B33F3E1FD3FFCFFFF3FFAF0913F75D8BA3AAFECFF3F12D5AC3F000000400000004045F0892939D7FF3F00000040A71DA73C46B8F53F00000040739CDE353FF4FF3FF2FFFF3FF1754C3A25F0FF3FBEA3733FB207522EAD53AC38A05DE93F10F1F83F6315483463BBFF3F12E95433F6FFFF3FDA38FF3F584FF73FAB04792A6D44F93FD8FBFD3F6168F13FA6FEFF3F03F6773D7DC46E3FC58EE437140F143C00000040AC87A03E00000040F1ADFE3F0000004004118E3F1834A1292A89FD3FE2F3E63F226EC53E3372243DA0FFFF3FB7ECFF3F5DD5EB3F3BF897337AA6403F71EFFF3FA9368E39B9146D3E64929B3B"> : tensor<20x20xf32>
    return %cst : tensor<20x20xf32>
  }
}