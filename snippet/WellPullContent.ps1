#https://devblogs.microsoft.com/scripting/convert-a-web-page-into-objects-for-easy-scraping-with-powershell/
function Get-PSGalleryInfo {

    param(

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]       

        $Name

    )

    Begin {

$t = @"

{Name*:PowerShellISE-preview} {[version]Version:5.1.0.1} (this version) {[double]Downloads:885} {[DateTime]PublishDate:Wednesday, January 27 2016}

{Name*:ImportExcel} 1.97  {Downloads:106} Monday, January 18 2016

"@

    }

 

    Process {

        $url ="https://www.powershellgallery.com/packages/$Name/"

       

        $r=Invoke-WebRequest $url

        ($r.AllElements | Where {$_.class -match 'versionTableRow'}).innerText |

            ConvertFrom-String -TemplateContent $t

    }

}
