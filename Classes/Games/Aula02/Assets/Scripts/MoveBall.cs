using TMPro;
using UnityEngine;

[RequireComponent(typeof(Rigidbody))]
public class MoveBall : MonoBehaviour
{
    Rigidbody rb;
    bool isGrounded;
    public float moveSpeed = 3;
    public float jumpSpeed = 5;
    private float prevJumpSpeed;
    void Start()
    {
        rb = this.GetComponent<Rigidbody>();
        addPointsToScore(0);
    }

    // Update is called once per frame
    void Update()
    {
        isGrounded = Physics.Raycast(transform.position, Vector3.down, 0.8f, LayerMask.GetMask("jumpable"));

        rb.AddForce(Input.GetAxis("Horizontal") * moveSpeed, 0, 0);

        if (Input.GetKeyDown(KeyCode.Space) && isGrounded)
        {
            rb.AddForce(Vector3.up * jumpSpeed, ForceMode.Impulse);
        }
    }

    private void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.tag == "platform")
        {
            collision.gameObject.GetComponent<MeshRenderer>().material.color = Color.green;
            prevJumpSpeed = jumpSpeed;
            jumpSpeed = jumpSpeed * 2;
        }

    }

    private void OnCollisionStay(Collision collision)
    {
        if (collision.gameObject.CompareTag("chest"))
        {
            jumpSpeed = 0;
            moveSpeed = 0;
            Destroy(collision.gameObject);
            addPointsToScore(100);
        }
    }

    private void OnCollisionExit(Collision collision)
    {
        if (collision.gameObject.tag == "platform")
        {
            jumpSpeed = prevJumpSpeed;
            collision.gameObject.GetComponent<MeshRenderer>().material.color = Color.white;
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("coin"))
        {
            Destroy(other.gameObject);
            addPointsToScore(10);
        } else if (other.CompareTag("chest"))
        {
            Destroy(other.gameObject);
            addPointsToScore(100);
            rb.AddForce(Vector3.zero, ForceMode.Impulse);
            //var player = GameObject.FindGameObjectWithTag("ball");
            //player.SetActive(false);
        }
    }

    private void addPointsToScore(int pointsToAdd) {
        var gameManager = FindObjectOfType<GameManager>();

        if (gameManager != null)
        {
            gameManager.AddPoints(pointsToAdd);

            var txt = FindObjectOfType<TextMeshPro>();
            txt.text = $"Score: {gameManager.points}";
        }
    }
}