function Test-Challange() {
    param(
        $Challange,
        $Success
    )

    if ($Success) {
        Write-Host "Success ✔" -ForegroundColor green
    }
    else {
        Write-Host "❌ The challange $Challange was unfortunately not yet passed 😢" -ForegroundColor red
    }

}
