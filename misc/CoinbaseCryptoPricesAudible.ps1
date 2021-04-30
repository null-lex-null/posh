$cryptopair = @('LTC-USD', 'BTC-USD', 'ETH-USD')
Add-Type -AssemblyName System.speech
$speak = New-Object System.Speech.Synthesis.SpeechSynthesizer
foreach ($crypto in $cryptopair) {
    $price = $null
    $price = (Invoke-RestMethod -Method GET -Uri https://api.coinbase.com/v2/prices/$crypto/spot).Data     
    $LTC = $price.base.replace('LTC', 'Litecoin')
    $BTC = $price.base.replace('BTC', 'Bitcoin')
    $ETH = $price.base.replace('ETH', 'Ethereum')
  
    IF ($crypto -match 'LTC-USD') { $speak.Speak("$LTC"); $speak.speak("$($price.amount)"); $speak.speak("$($price.currency)") }
    IF ($crypto -match 'BTC-USD') { $speak.Speak("$BTC"); $speak.speak("$($price.amount)"); $speak.speak("$($price.currency)") }
    IF ($crypto -match 'ETH-USD') { $speak.Speak("$ETH"); $speak.speak("$($price.amount)"); $speak.speak("$($price.currency)") }
}