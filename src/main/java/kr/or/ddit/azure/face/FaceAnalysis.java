package kr.or.ddit.azure.face;

import java.net.URI;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.client.utils.URIBuilder;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.util.EntityUtils;
import org.json.JSONArray;
import org.json.JSONObject;

/*
	이 데이터는 Face 서비스에 연결하는 방법과 입력 데이터를 가져올 위치를 지정합니다.
	subscriptionKey 필드를 구독 키의 값으로 업데이트하고, 올바른 엔드포인트 문자열이 포함되도록 uriBase 문자열을 변경해야 합니다.
	imageWithFaces 값을 다른 이미지 파일을 가리키는 경로로 설정할 수도 있습니다.
	faceAttributes 필드는 단순히 특정 유형의 특성 목록입니다. 감지된 얼굴에 대해 검색할 정보를 지정합니다.
*/

/*
 * To compile and run, enter the following at a command prompt:
 *   javac Detect.java -cp .;lib\*
 *   java -cp .;lib\* Detect
 */

public class FaceAnalysis {
	
	private static final String subscriptionKey = "cae766a534074d6b89f02281da4e14cf";
    private static final String endpoint = "https://faceanalysis-jh.cognitiveservices.azure.com/";

    private static final String imageWithFaces =
        "{\"url\":\"https://upload.wikimedia.org/wikipedia/commons/c/c3/RH_Louise_Lillian_Gish.jpg\"}";
    
    /*
      다음 코드로 main 메서드를 추가합니다.
      Face API에 대한 REST 호출을 구성하여 원격 이미지의 얼굴 정보를 감지합니다(검색할 얼굴 특성을 지정하는 faceAttributes 문자열).
      그런 다음, 출력 데이터를 JSON 문자열에 기록합니다.
    */
    public static void main(String[] args) {
        HttpClient httpclient = HttpClientBuilder.create().build();
        
        //System.out.println(1 + subscriptionKey);
        //System.out.println(1 + endpoint);
        //System.out.println(1 + imageWithFaces);
        
        try
        {
            URIBuilder builder = new URIBuilder(endpoint + "/face/v1.0/detect");
            //System.out.println(2);

            // Request parameters. All of them are optional.
            builder.setParameter("detectionModel", "detection_01");
            builder.setParameter("returnFaceAttributes", "age,gender,headPose,smile,facialHair,glasses,emotion,hair,makeup,occlusion,accessories,blur,exposure,noise");
            //System.out.println("3" + builder);

            // Prepare the URI for the REST API call.
            URI uri = builder.build();
            HttpPost request = new HttpPost(uri);
            //System.out.println("4" + uri);

            // Request headers.
            request.setHeader("Content-Type", "application/json");
            request.setHeader("Ocp-Apim-Subscription-Key", subscriptionKey);
            //System.out.println(5);

            // Request body.
            StringEntity reqEntity = new StringEntity(imageWithFaces);
            request.setEntity(reqEntity);
            //System.out.println("6" + reqEntity);

            // Execute the REST API call and get the response entity.
            HttpResponse response = httpclient.execute(request);
            //System.out.println(7);
            HttpEntity entity = response.getEntity();
            //System.out.println(8);
            
            if (entity != null)
            {
                // Format and display the JSON response.
                System.out.println("REST Response:\n");

                //System.out.println(9);
                
                String jsonString = EntityUtils.toString(entity).trim();
                if (jsonString.charAt(0) == '[') {
                    JSONArray jsonArray = new JSONArray(jsonString);
                    System.out.println(jsonArray.toString(2));
                }
                else if (jsonString.charAt(0) == '{') {
                    JSONObject jsonObject = new JSONObject(jsonString);
                    System.out.println(jsonObject.toString(2));
                } else {
                    System.out.println(jsonString);
                }
            }
        }
        catch (Exception e)
        {
            // Display error message.
            System.out.println(e.getMessage());
        }
    }
}

