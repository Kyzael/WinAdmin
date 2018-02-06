$users = $args

foreach ($user in $users)
{
    $groups = ((Get-ADPrincipalGroupMembership $user).where({$_.GroupCategory -EQ 'Distribution'}) | Select-Object -Property Name)
   
    foreach ($group in $groups) 
    { 
        Remove-ADPrincipalGroupMembership -Identity $username -MemberOf $group.name
    }
}