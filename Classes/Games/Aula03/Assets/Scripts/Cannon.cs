using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Cannon : MonoBehaviour
{
    public GameObject prefabToInstantiate;
    Transform spawnPoint;
    public float shootSpeed = 10;
    // Start is called before the first frame update
    void Start()
    {
        spawnPoint = transform.GetChild(0);
    }

    // Update is called once per frame
    void Update()
    {
        if(Input.GetKeyDown(KeyCode.Space))
        {
            GameObject aux;
            aux = Instantiate(prefabToInstantiate, spawnPoint.position, spawnPoint.rotation);
            aux.GetComponent<Rigidbody>().AddForce(spawnPoint.forward * shootSpeed, ForceMode.Impulse);
        }
    }
}
