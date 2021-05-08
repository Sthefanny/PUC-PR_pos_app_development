using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Rigidbody))]
public class MoveBall : MonoBehaviour
{
    Rigidbody rb;
    public float moveSpeed = 3;
    public float jumpSpeed = 5;
    void Start()
    {
        rb = GetComponent<Rigidbody>();
    }

    // Update is called once per frame
    void Update()
    {
        rb.AddForce(Input.GetAxis("Horizontal"), 0, Input.GetAxis("Vertical")*moveSpeed);
        
        if(Input.GetKeyDown(KeyCode.Space))
        {
            rb.AddForce(Vector3.up * jumpSpeed, ForceMode.Impulse);
        }
    }
}