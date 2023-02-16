#!/bin/bash 

read -p "Enter your API name (snake case) : " api_name
read -p "Is this API public? (Y/N): " is_public
read -p "Add title of this API: " title
read -p "Add description of this API: " description
read -p "Add package name in controllers: " package
read -p "Add tags (use , to add more than one tags): " tags

# echo '$api_name:' $api_name
# echo '$is_public:' $is_public

FilePath=`echo controllers/${package}/${api_name}.go`

touch ${FilePath}

ApiName=`echo ${api_name} | perl -pe 's/(^|_)./uc($&)/ge;s/_//g'`

# echo "${ApiName}" 

echo "package ${package}" >> ${FilePath}
echo "" >> ${FilePath}

echo "import (" >> ${FilePath}
echo "	\"github.com/gin-gonic/gin\"" >> ${FilePath}
echo "	\"github.com/otsofintech/s-lib/slibpb\"" >> ${FilePath}
echo ")" >> ${FilePath}
echo "" >> ${FilePath}

echo "// @Description ${ApiName} Request" >> ${FilePath}
echo "type ${ApiName}Request struct {" >> ${FilePath}
echo "	GroupId     int64  \`json:\"group_id,string\"\`" >> ${FilePath}
echo "	Username    string \`json:\"username\"  validate:\"required\"\`" >> ${FilePath}
echo "}" >> ${FilePath}
echo "" >> ${FilePath}
  
echo "// @Description ${ApiName} Response" >> ${FilePath}
echo "type ${ApiName}Response struct {" >> ${FilePath}
echo "	Error *slibpb.Error" >> ${FilePath}
echo "	Data  *Data" >> ${FilePath}
echo "}" >> ${FilePath}
echo "" >> ${FilePath}

echo "// @Description ${ApiName} Data" >> ${FilePath}
echo "type Data struct {" >> ${FilePath}
echo "	Id          int64  \`json:\"id,string\"\`" >> ${FilePath}
echo "	Username    string \`json:\"username\"\`" >> ${FilePath}
echo "}" >> ${FilePath}
echo "" >> ${FilePath}

echo "// ${api_name} godoc" >> ${FilePath}
echo "// @Summary                   ${title}" >> ${FilePath}
echo "// @Description               ${description}" >> ${FilePath}


if [[ $is_public == "Y" ]]; 
then
  echo "// @Tags                      public" >> ${FilePath}
else 
  echo "// @Tags                      ${tags}" >> ${FilePath}
fi

echo "// @Accept                    json" >> ${FilePath}
echo "// @Produce                   json" >> ${FilePath}
echo "// @Param                     body body     ${ApiName}Request true \"${ApiName}Request\"" >> ${FilePath}
echo "// @Success                   200  {object} ${ApiName}Response    \"[error code list](http://localhost:3000/general/error)\"" >> ${FilePath}
echo "// @Failure                   400  {object} api.Response            \"[error code list](http://localhost:3000/general/error)\"" >> ${FilePath}
echo "// @Failure                   500  {object} api.Response            \"[error code list](http://localhost:3000/general/error)\"" >> ${FilePath}
echo "// @securityDefinitions.basic BasicAuth" >> ${FilePath}

if [[ $is_public == "N" ]]; then
  echo "// @x-internal true" >> ${FilePath}
fi

echo "// @Router                    /${package}/${api_name} [post]" >> ${FilePath}
echo "func ${api_name}(c *gin.Context) {" >> ${FilePath}
echo "}" >> ${FilePath}
echo "" >> ${FilePath}

