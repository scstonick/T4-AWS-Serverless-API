//let AWS = require('aws-sdk');

const GetSecretValueCommand = 
  require("@aws-sdk/client-secrets-manager/dist-cjs/commands/GetSecretValueCommand.js");

const SecretsManagerClient = 
require("@aws-sdk/client-secrets-manager/dist-cjs/SecretsManagerClient.js");

exports.getSecrets = async () => {
  
  const client = new SecretsManagerClient.SecretsManagerClient({ region: "us-east-1", });
  const secret_name = "ExampleNameSecr";
  let secret, value;

  try 
  {
    value = await client.send(
        new GetSecretValueCommand.GetSecretValueCommand({
            SecretId: secret_name,
            VersionStage: "AWSCURRENT", // VersionStage defaults to AWSCURRENT if unspecified
        })
    );
  } catch (error) {
    // For a list of exceptions thrown, see
    // https://docs.aws.amazon.com/secretsmanager/latest/apireference/API_GetSecretValue.html
    throw error;
  }

  secret = value.SecretString;


  return secret;

}