# ConvertTimeZone

######################################################
# UTC 2 JST
######################################################
function UTC2JST([datetime]$DateTime){
    # タイムゾーン
    $SrcTimeZone = "UTC"
    $DstTimeZone = "Tokyo Standard Time"

    return CalcLocalTime $DateTime $SrcTimeZone $DstTimeZone
}



######################################################
# JST to UTC
######################################################
function JST2UTC([datetime]$DateTime){
    # タイムゾーン
    $SrcTimeZone = "Tokyo Standard Time"
    $DstTimeZone = "UTC"

    return CalcLocalTime $DateTime $SrcTimeZone $DstTimeZone
}


######################################################
# 時間変換
######################################################
function CalcLocalTime([datetime]$DateTime, $SrcTimeZone, $DstTimeZone){
    [TimeSpan]$Offset = ([System.TimeZoneInfo]::FindSystemTimeZoneById($SrcTimeZone)).GetUtcOffset($DateTime)
    [datetimeoffset]$TergetTime = New-Object DateTimeOffset( $DateTime, $Offset )

    $TergetTimeTimeZone = [System.TimeZoneInfo]::FindSystemTimeZoneById($SrcTimeZone)
    if( $TergetTimeTimeZone.IsInvalidTime( $TergetTime.DateTime)){
        echo "[ERROR] $DateTime はサマータイム開始時のため存在しない時刻です"
        exit
    }

    [datetimeoffset]$Pst = [System.TimeZoneInfo]::ConvertTimeBySystemTimeZoneId($TergetTime, $DstTimeZone)

    $ReturnData = New-Object PSObject | Select-Object LocalTime, SummerTime
    $ReturnData.LocalTime = $Pst.DateTime

    $PstTimeZone = [System.TimeZoneInfo]::FindSystemTimeZoneById($DstTimeZone)
    $ReturnData.SummerTime = $PstTimeZone.IsDaylightSavingTime($Pst.DateTime)

    return $ReturnData
}

