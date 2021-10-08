# A REST API is simply an interface for interacting with a server. Full details on
# the API functionality can be found at: https://docs.microsoft.com/en-us/rest/api/power-bi/

Install-Module -Name MicrosoftPowerBIMgmt # please type this line into your PowerShell console

Login-Power BI # This initial line will open up a login screen for the Power BI service

<# 
Ensure you find the group ID for your content. This is located in the URL of your workspace
E.g., app.powerbi.com/groups/<YOUR-GROUP-ID>/list
Also note how in PowerShell, variables are initialized and called using the dollar-sign 
#>
$result = Invoke-PowerBIRestMethod - URL"https://api.powerbi.com/v1.0/myorg/groups/<YOUR-GROUP-ID>/datasets" -Method Get

<# 
Unlike in R where piping is performed with %>% when using the Tidyverse
and |> in base R, PowerShell uses an actual pipe character to transfer the
contents of $result to the function 'ConvertFrom-Json'
#>
$workspaceContents = $result | ConvertFrom-Json 

# For testing purposes, let's try to extract the contents of the first report listed.
# type this into the console and then call $firstWorkspace
$firstWorkspace = $workspaceContents.value[0]

# Of course, it's bad practice to specify an object by referencing a direct location.
# What if that changes? Let's set up the basis of a for-loop by getting the number
# of reports stored in our workspace:
$m = $workspaceContents.value | measure

<# 
Now we can create our for-loop. Note the similarities of a PowerShell 
for-loop structure with Java syntax. '-lt' is a less-than operator here,
specifying to iterate i (beginning at 0) with increments of 1 until it 
reaches less than the value of $m.Count
#>
for ($i=0; $i -lt $m.Count; $i++){
    if ($workspaceContents.value[$i].name -eq "My Geospatial Report"){ # '-eq' is the equals operator
        $desired_report = $workspaceContents.value[$i]
        Write-Host "The report was found!" # this is a print-to-console operation
        break # this stops the loop at the current iteration
    }
}

# call the report metadata:
$desired_report