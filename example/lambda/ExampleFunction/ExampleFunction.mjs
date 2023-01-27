//let AWS = require('aws-sdk');
import layerSecrets from "/opt/layerSecrets.js";
  
import middy from '@middy/core'



let SMSecret;
  
export const handler = middy((event, context, callback) => {
  

  const response = {
    statusCode: 200,
    body: "test"
  };
  return response;

})
.before(async (request) => {
  if (layerSecrets != null)
  {
    console.log(layerSecrets);
  }
  SMSecret = await layerSecrets.getSecrets();
})
.after(async (request) => {
  // do something in the after phase
})
.onError(async (request) => {
  // do something in the on error phase
})