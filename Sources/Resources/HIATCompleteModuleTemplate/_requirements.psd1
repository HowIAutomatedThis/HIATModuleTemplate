@{
    PSDependOptions = @{
        Target             = '$pwd/Dependencies'
        SkipPublisherCheck = $true
        AddToPath          = $true
    }
    'BuildHelpers'    = @{
        Version = '2.0.15'
    }
}