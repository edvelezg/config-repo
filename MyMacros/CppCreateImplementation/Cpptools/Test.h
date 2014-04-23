class Test {
public:
    Test();
    ~Test();

    bool WriteData(BYTE *pBuffer, size_t bytes);
    bool ReadData(BYTE *pBuffer, size_t bytes);

private:
    BYTE *m_pInternal;
};
