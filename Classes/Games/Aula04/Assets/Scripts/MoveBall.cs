using UnityEngine;
using UnityEngine.UI;

public class MoveBall : MonoBehaviour
{
    public Text debugTextBox1;
    public Text debugTextBox2;

    Rigidbody rb;
    public float speed = 3;

    // Start is called before the first frame update
    void Start()
    {
        rb = GetComponent<Rigidbody>();
    }

    // Update is called once per frame
    void Update()
    {
        debugTextBox1.text = "Dedos: " + Input.touchCount;

        debugTextBox2.text = "X: " + Input.acceleration.x.ToString("N2") + "\n" +
                             "Y: " + Input.acceleration.y.ToString("N2") + "\n" +
                             "Z: " + Input.acceleration.z.ToString("N2");

        if (Input.touchCount > 0)
            if (Input.GetTouch(0).phase == TouchPhase.Began)
                rb.AddForce(Vector3.up * speed, ForceMode.Impulse);
    }

    private void FixedUpdate()
    {
        rb.AddForce(Input.acceleration.x * speed, 0, Input.acceleration.y * speed);
    }
}
