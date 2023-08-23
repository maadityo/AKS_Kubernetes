Param(
    $acrname = "kizacr",    
    $imageprefix = "mt3chained"
)

$imagename = "$($imageprefix)-web"
az acr build --registry $acrname --image "$($imagename):latest" --file ./Chained/MT3Chained-Web/Dockerfile ./Chained/MT3Chained-Web/.
for (($i = 1); $i -lt 6; $i++) {
    $step = $i
    $imagename = "mt3chained-step$($step)"
    az acr build --registry $acrname --image "$($imagename):latest" --file "./Chained/MT3Chained-Step$($step)/Dockerfile" .
}
$imagename = "mt3chained-step2-nodejs"
$folder = ".Module3/MathTrick/Chained/Chained - Shortcut.lnk/Chained/MT3Chained-Step2-NodeJS/"
Set-Location $folder
az acr build --registry $acrname --image "$($imagename):latest" --file "Dockerfile" .
Set-Location ../..