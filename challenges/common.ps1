function Test-Challenge() {
    param(
        $Challenge,
        $Success
    )

    if ($Success) {
        Write-Host "✔ You passed challenge $Challenge 💪" -ForegroundColor green
    }
    else {
        Write-Host "❌ The challenge $Challenge was unfortunately not yet passed 😢" -ForegroundColor red
    }

}
