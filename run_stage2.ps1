conda run -n snakemake snakemake --cores 4 report_metalog_bmi_13k.html
if ($?) {
    Write-Host "13k run successful. Waiting 5s before 15k..."
    Start-Sleep -Seconds 5
    Write-Host "Starting 15k run..."
    conda run -n snakemake snakemake --cores 4 report_metalog_bmi_15k.html --config dataset_name=metalog_bmi_15k dataset_csv=data/metalog_bmi_15k.csv
}
else {
    Write-Host "13k run failed. Aborting 15k run."
}
