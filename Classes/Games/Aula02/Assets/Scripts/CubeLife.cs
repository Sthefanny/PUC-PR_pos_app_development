using UnityEngine;

public class CubeLife : MonoBehaviour
{
    int touchCount = 0;
    // Start is called before the first frame update
    void Start()
    {
    }

    // Update is called once per frame
    void Update()
    {

    }

    void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.CompareTag("ball"))
        {
            var saturation = 0f;

            switch (touchCount)
            {
                case 0:
                    saturation = 0.3f;
                    break;
                case 1:
                    saturation = 0.6f;
                    break;
                case 2:
                    saturation = 1f;
                    break;
                default:
                    return;
            }
            touchCount++;
            this.transform.GetComponent<MeshRenderer>().material.color = Color.HSVToRGB(0, saturation, 1f);
        }
    }

    void OnCollisionExit(Collision collision)
    {
        if (touchCount == 3)
        {
            Destroy(this.gameObject);
        }
    }
}
